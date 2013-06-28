require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/partial'
require 'rest-client'

require_relative 'lib/core_client'

configure do
  set :client, CoreClient.new(ENV["MASHERY_KEY"])
  if ENV["SERVER_ENV"] == "sandbox"
    RestClient.proxy = "http://www-cache.reith.bbc.co.uk:80"
  end
end

get '/' do
  @page = params[:page] || 1
  @cworks = settings.client.creative_works({ legacy: true, page: @page })
  @page_title = "Creative Works"
  haml :index
end

get '/about/:guid' do
  @page = params[:page] || 1
  @cworks = settings.client.creative_works({legacy: true, about: params[:guid], page: @page})
  
  thing = client.things({uri: params[:guid]})
  if thing
    @title = thing["name"] || thing["label"]
  end
  
  @page_title = @title || "Detail"
  haml :index 
end

get '/search' do
  @results = settings.client.tag_concepts({legacy: true, search: params[:q]})
  @page_title = "Search for '#{params[:q]}'"
  haml :search
end