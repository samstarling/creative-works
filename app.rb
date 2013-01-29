require 'rubygems'
require 'sinatra'
require 'json'

get '/' do
  haml :index
end

get '/data' do
  {
    :d => Time.now
  }.to_json
end