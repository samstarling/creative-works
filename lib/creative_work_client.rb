require 'rest_client'
require 'json'
require 'retriable'

RestClient.proxy = "http://www-cache.reith.bbc.co.uk:80"

MASHERY_KEY = ENV["MASHERY_KEY"]
MASHERY_BASE = "http://bbc.api.mashery.com/ldp"

class ThingsClient
  def self.get_thing uri
    response = BBCRestClient.get "#{MASHERY_BASE}/things?uri=#{uri}&api_key=#{MASHERY_KEY}"
    json = JSON.parse(response)
    json['canonicalName']
  end
end

class CreativeWorkClient
  def self.latest
    retriable :tries => 5, :interval => 1 do
      response = BBCRestClient.get "#{MASHERY_BASE}/creative-works?legacy=true&api_key=#{MASHERY_KEY}"
      CreativeWorkParser.parse response
    end
  end
  
  def self.about uri
    retriable :tries => 5, :interval => 1 do
      response = BBCRestClient.get "#{MASHERY_BASE}/creative-works?legacy=true&about=#{uri}&api_key=#{MASHERY_KEY}"
      CreativeWorkParser.parse response
    end
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
  
  def date
    DateTime.parse(@json['dateCreated']).strftime("%-d %B at %H:%M")
  end
  
  def about
    if @json['about']
      if @json['about'].class == Array
        @json['about'].map { |tag| Tag.new tag }
      else
        tag = Tag.new @json['about']
        [tag, ]
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
        big_thumbnail = @json['thumbnail'].select { |t| t['thumbnailType'] == "FixedSize226Thumbnail" }
        if big_thumbnail.first
          big_thumbnail.first['@id']
        else
          nil
        end
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
  
  def uri
    @json['@id']
  end
  
  def href
    "/about/#{URI.escape(uri).gsub('/', '%2F').gsub(':', '%3A')}"
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