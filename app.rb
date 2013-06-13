require 'rubygems'
require 'sinatra'
require 'json'

require_relative 'lib/creative_work_client.rb'

get '/' do
  haml :index
end

get '/data' do
  CreativeWorkClient.latest
end