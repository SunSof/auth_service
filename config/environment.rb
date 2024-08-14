require "bundler/setup"
Bundler.require(:default)
require "sinatra/activerecord"
require "./models/user"
require "./models/refresh_token"
require "./lib/jwt_service"
