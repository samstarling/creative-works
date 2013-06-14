require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/partial'

require_relative 'lib/creative_work_client.rb'

get '/old' do
  haml :index
end

get '/' do
  @cworks = CreativeWorkClient.latest
  haml :list
end

get '/about/:guid' do
  guid = params[:guid]
  @cworks = CreativeWorkClient.about guid
  @title = ThingsClient.get_thing guid
  haml :list 
end

get '/data' do
  CreativeWorkClient.latest
end