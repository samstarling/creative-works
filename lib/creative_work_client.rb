require 'rest_client'
require 'json'

RestClient.proxy = "http://www-cache.reith.bbc.co.uk:80"

class CreativeWorkClient
  MASHERY_KEY = ENV["MASHERY_KEY"]
  MASHERY_BASE = "http://bbc.api.mashery.com/ldp"
  
  def self.latest
    response = BBCRestClient.get "#{MASHERY_BASE}/creative-works?legacy=true&api_key=#{MASHERY_KEY}"
    CreativeWorkParser.parse response
  end
end

class CreativeWorkParser
  def  self.parse json
    parsed = JSON.parse(json)
    parsed['@list'].map { |cw| CreativeWork.new parsed, cw }
  end
end

class CreativeWork
  def initialize list_json, item_json
    @list_json = list_json
    @json = item_json
  end
  
  def title
    @json['title']
  end
  
  def about
    if @json['about']
      if @json['about'].class == Array
        @json['about'].map { |tag| Tag.new tag }
      else
        tag = Tag.new @json['about']
        abouts = Array.new
        abouts << tag
        abouts
      end
    else
      nil
    end
  end
  
  def description
    @json['description']
  end
  
  def thumbnail
    if @json['thumbnail']
      if @json['thumbnail'].class == Array
        @json['thumbnail'].last['@id']
      else
        if @json['thumbnail']['@id']
          @json['thumbnail']['@id']
        else
          nil
        end
      end
      
    else
      nil
    end
  end
end

class Tag
  def initialize json
    @json = json
  end
  
  def to_s
    label
  end
  
  def label
    if @json['preferredLabel']
      @json['preferredLabel']
    else
      if @json['label'].class == Array
        @json['label'].first
      else
        @json['label']
      end
    end
  end
  
  def link
    @json['id']
  end
end

class BBCRestClient
  def self.get url
    RestClient::Resource.new(
      url,
      :ssl_client_cert => OpenSSL::X509::Certificate.new(File.open(File.join(File.dirname(__FILE__), '..', 'certificate.pem'))),
      :ssl_client_key => OpenSSL::PKey::RSA.new(File.open(File.join(File.dirname(__FILE__), '..', 'certificate.pem'))),
    ).get(:accept => "application/json-ld")
  end
end