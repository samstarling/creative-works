require 'rest_client'
require 'json'
require 'retriable'

#RestClient.proxy = "http://www-cache.reith.bbc.co.uk:80"
#
#MASHERY_KEY = ENV["MASHERY_KEY"]
##MASHERY_BASE = "http://bbc.api.mashery.com/stage/ldp"
#MASHERY_BASE = "http://bbc.api.mashery.com/ldp"
#
#class ThingsClient
#  def self.get_thing guid
#    url = "#{MASHERY_BASE}/things?uri=#{guid}&api_key=#{MASHERY_KEY}"
#    response = BBCRestClient.get url
#    json = JSON.parse(response)
#    json['canonicalName']
#  end
#end
#
#class CreativeWorkClient
#  def self.latest
#    retriable :tries => 5, :interval => 1 do
#      url = "#{MASHERY_BASE}/creative-works?legacy=true&api_key=#{MASHERY_KEY}"
#      response = BBCRestClient.get url
#      CreativeWorkParser.parse response
#    end
#  end
#  
#  def self.about guid
#    retriable :tries => 5, :interval => 1 do
#      url = "#{MASHERY_BASE}/creative-works?legacy=true&about=#{guid}&api_key=#{MASHERY_KEY}"
#      response = BBCRestClient.get url
#      CreativeWorkParser.parse response
#    end
#  end
#end
#
#class CreativeWorkParser
#  def  self.parse json
#    parsed = JSON.parse(json)
#    
#    cws = if parsed['@list']
#      parsed['@list']
#    elsif parsed['results']
#      parsed['results']
#    else
#      throw "No CWs found"
#    end
#    
#    cws.map { |cw| CreativeWorkOld.new parsed, cw }
#  end
#end
#
#class CreativeWorkOld
#  def initialize list_json, item_json
#    @list_json = list_json
#    @json = item_json
#  end
#  
#  def title
#    @json['title']
#  end
#  
#  def href
#    if @json['primaryContentOf']
#      if @json['primaryContentOf'].class == Array
#        @json['primaryContentOf'].select { |l| !l.include? "mobile" }.first
#      else
#        @json['primaryContentOf']
#      end
#    else
#      nil
#    end
#  end
#  
#  def date
#    DateTime.parse(@json['dateCreated']).strftime("%-d %B at %H:%M")
#  end
#  
#  def about
#    if @json['about']
#      if @json['about'].class == Array
#        @json['about'].map { |tag| Tag.new tag }
#      else
#        tags = Array.new
#        tag = Tag.new @json['about']
#        tags << tag
#        tags
#      end
#    else
#      nil
#    end
#  end
#  
#  def description
#    @json['description']
#  end
#  
#  def thumbnail
#    if @json['thumbnail']
#      if @json['thumbnail'].class == Array
#        big_thumbnail = @json['thumbnail'].select { |t| t['thumbnailType'] == "FixedSize226Thumbnail" }
#        if big_thumbnail.first
#          big_thumbnail.first['@id']
#        else
#          "http://placekitten.com/226/170"
#        end
#      else
#        if @json['thumbnail']['@id']
#          @json['thumbnail']['@id']
#        else
#          "http://placekitten.com/226/170"
#        end
#      end
#    else
#      "http://placekitten.com/226/170"
#    end
#  end
#end

