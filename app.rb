require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/partial'

require_relative 'lib/creative_work_client'
require_relative 'lib/core_client'

get '/' do
  client = CoreClient.new ENV["MASHERY_KEY"]
  @cworks = client.creative_works legacy=true
  haml :index
end

get '/about/:guid' do
  guid = params[:guid]
  @cworks = CreativeWorkClient.about guid
  @title = ThingsClient.get_thing guid
  @page_title = @title
  haml :list 
end