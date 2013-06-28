require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/partial'
require 'rest-client'

require_relative 'lib/core_client'

# NB: Castleford = 663de257-779e-4869-bd68-6c469a984469

if ENV["SERVER_ENV"] == "sandbox"
  RestClient.proxy = "http://www-cache.reith.bbc.co.uk:80"
end

get '/' do
  client = CoreClient.new ENV["MASHERY_KEY"]
  @page = params[:page] || 1
  @cworks = client.creative_works({ legacy: true, page: @page })
  @page_title = "Creative Works"
  haml :index
end

get '/about/:guid' do
  client = CoreClient.new ENV["MASHERY_KEY"]
  @page = params[:page] || 1
  @cworks = client.creative_works({ legacy: true, about: params[:guid], page: @page })
  
  # TODO Tidy up this bit
  thing = client.things({uri: params[:guid]})
  if thing
    @title = thing["name"] || thing["label"]
  end
  
  @page_title = @title || "Detail"
  haml :index 
end

get '/search' do
  client = CoreClient.new ENV["MASHERY_KEY"]
  @results = client.tag_concepts({ legacy: true, search: params[:q] })
  @page_title = "Search for '#{params[:q]}'"
  haml :search
end