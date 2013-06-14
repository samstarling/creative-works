require 'rest_client'
require 'json'
require 'retriable'

#RestClient.proxy = "http://www-cache.reith.bbc.co.uk:80"

MASHERY_KEY = ENV["MASHERY_KEY"]
#MASHERY_BASE = "http://bbc.api.mashery.com/stage/ldp"
MASHERY_BASE = "http://bbc.api.mashery.com/ldp"

class ThingsClient
  def self.get_thing guid
    url = "#{MASHERY_BASE}/things?uri=#{guid}&api_key=#{MASHERY_KEY}"
    response = BBCRestClient.get url
    json = JSON.parse(response)
    json['canonicalName']
  end
end

class CreativeWorkClient
  def self.latest
    retriable :tries => 5, :interval => 1 do
      url = "#{MASHERY_BASE}/creative-works?legacy=true&api_key=#{MASHERY_KEY}"
      response = BBCRestClient.get url
      CreativeWorkParser.parse response
    end
  end
  
  def self.about guid
    retriable :tries => 5, :interval => 1 do
      url = "#{MASHERY_BASE}/creative-works?legacy=true&about=#{guid}&api_key=#{MASHERY_KEY}"
      response = BBCRestClient.get url
      CreativeWorkParser.parse response
    end
  end
end

class CreativeWorkParser
  def  self.parse json
    parsed = JSON.parse(json)
    
    cws = if parsed['@list']
      parsed['@list']
    elsif parsed['results']
      parsed['results']
    else
      throw "No CWs found"
    end
    
    cws.map { |cw| CreativeWork.new parsed, cw }
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
  
  def href
    if @json['primaryContentOf']
      if @json['primaryContentOf'].class == Array
        @json['primaryContentOf'].select { |l| !l.include? "mobile" }.first
      else
        @json['primaryContentOf']
      end
    else
      nil
    end
  end
  
  def date
    DateTime.parse(@json['dateCreated']).strftime("%-d %B at %H:%M")
  end
  
  def about
    if @json['about']
      if @json['about'].class == Array
        @json['about'].map { |tag| Tag.new tag }
      else
        tags = Array.new
        tag = Tag.new @json['about']
        tags << tag
        tags
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
        if @json['label']
          @json['label']
        else
          @json
        end
      end
    end
  end
  
  def uri
    if @json['@id']
      @json['@id']
    else
      nil
    end
  end
  
  def guid
    if uri
      match = uri.match(/(([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12})/)
      if match
        match[1]
      else
        nil
      end
    else
      nil
    end
  end
  
  def href
    if uri
      #"/about/#{URI.escape(uri).gsub('/', '%2F').gsub(':', '%3A')}"
      "/about/#{guid}"
    end
  end
end

class BBCRestClient
  def self.get url
    RestClient::Resource.new(url).get(:accept => "application/json-ld")
  end
end