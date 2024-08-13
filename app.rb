require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "sinatra/json"
require "sinatra/param"
require "bcrypt"
require "./models/user"
require "./lib/jwt_service"

autoload :JwtService, "./jwt_service"

set :database_file, "config/database.yml"

enable :sessions

register Sinatra::Reloader
Dotenv.load

get "/new" do
  jwt = JwtService.new(User.first, "1234.0.0.1")
  p jwt.jwt
end

get "/token" do
  param :guid, String, required: true, message: "GUID is required"
  user = User.find_by(guid: params["guid"])
  if user
    ip = request.ip
    JwtService.new(user, ip)
  else
    halt 403, "User not found"
  end
end
