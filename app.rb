require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/partial'
require 'rest-client'

require_relative 'lib/core_client'

if ENV['PASSWORD']
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == 'admin' and password == ENV['PASSWORD']
  end
end

configure do
  set :client, CoreClient.new(ENV["MASHERY_KEY"])
  if ENV["SERVER_ENV"] == "sandbox"
    RestClient.proxy = "http://www-cache.reith.bbc.co.uk:80"
  end
end

get '/' do
  @page = params[:page] || 1
  @cworks = settings.client.creative_works({page: @page})
  @page_title = "Creative Works"
  haml :index
end

get '/about/:guid' do
  @page = params[:page] || 1
  @cworks = settings.client.creative_works({about: params[:guid], page: @page})
  @title = settings.client.tag_concepts({uri: params[:guid]}).first
  @page_title = @title || "Detail"
  haml :index 
end

get '/search' do
  @results = settings.client.tag_concepts({search: params[:q]})
  @page_title = "Search for '#{params[:q]}'"
  haml :search
end