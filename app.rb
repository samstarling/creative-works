require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/partial'

require_relative 'lib/core_client'

# NB: Castleford = 663de257-779e-4869-bd68-6c469a984469

RestClient.proxy = "http://www-cache.reith.bbc.co.uk:80"

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