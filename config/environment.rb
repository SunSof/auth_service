require "bundler/setup"
Bundler.require(:default)
require "sinatra/activerecord"
require "./models/user"
require "./lib/jwt_service"
