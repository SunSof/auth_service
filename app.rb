require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "sinatra/json"
require "sinatra/param"
require "bcrypt"
require "./models/user"
require "./models/refresh_token"
require "./lib/jwt_service"
require "./jobs/send_mail_job"
require "sidekiq"
require_relative "config/sidekiq"

autoload :JwtService, "./jwt_service"

set :database_file, "config/database.yml"

enable :sessions

register Sinatra::Reloader
Dotenv.load

get "/token" do
  param :guid, String, required: true, message: "GUID is required"
  user = User.find_by(guid: params["guid"])

  if user
    ip = request.ip
    jwt_service = JwtService.new(user, ip)
    RefreshToken.find_by(user_guid: user.guid)&.destroy
    refresh_token = RefreshToken.create(user_guid: user.guid, ip: ip)
    content_type :json
    {
      access_token: jwt_service.access_token,
      refresh_token: refresh_token.refresh_token_hash
    }.to_json
  else
    halt 403, "User not found"
  end
end

get "/refresh" do
  param :refresh_token, String, required: true, message: "Refresh token is required"
  token = RefreshToken.find_by(refresh_token_hash: params[:refresh_token])
  date_time_now = Time.now
  if token.nil?
    halt 403, "Token not found"
  end
  if token.expire < date_time_now
    halt 403, "Token expired"
  end
  user = User.find_by(guid: token.user_guid)
  if request.ip != token.ip
    SendMailJob.perform_async(user.email)
  end
  jwt_service = JwtService.new(user, token.ip)
  token.refresh
  content_type :json
  {
    access_token: jwt_service.access_token,
    refresh_token: token.refresh_token_hash
  }.to_json
end
