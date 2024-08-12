require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "bcrypt"
require "./models/user"

set :database_file, "config/database.yml"

enable :sessions

register Sinatra::Reloader

get "/" do
  erb :index
end
get "/new" do
  erb :new
end

post "/new" do
  password_digest = BCrypt::Password.create(params[:password])
  User.create(
    name: params[:name],
    email: params[:email],
    password_digest: password_digest
  )
end
