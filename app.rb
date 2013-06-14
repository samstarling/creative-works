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

get '/about/:uri' do
  uri = URI.escape(params[:uri]).gsub('/', '%2F').gsub(':', '%3A')
  @cworks = CreativeWorkClient.about uri
  @title = ThingsClient.get_thing uri
  haml :list 
end

get '/data' do
  CreativeWorkClient.latest
end