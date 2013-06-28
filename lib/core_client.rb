require 'json'

require_relative 'creative_work'

class BBCRestClient
  def get url
    RestClient::Resource.new(url).get(:accept => "application/json-ld")
  end
end

class CoreClient
  def initialize api_key, rest_client = BBCRestClient.new, base_url = "http://bbc.api.mashery.com/ldp"
    @api_key = api_key
    @rest_client = rest_client
    @base_url = base_url
  end
    
  def creative_works legacy = false, about = nil
    if about
      get_and_parse "creative-works?legacy=#{legacy}&about=#{about}&api_key=#{@api_key}"
    else
      get_and_parse "creative-works?legacy=#{legacy}&api_key=#{@api_key}"
    end
  end
  
  private
  
  def get_and_parse path
    url = "#{@base_url}/#{path}"
    response = @rest_client.get url

    if response.code != 200
      raise CoreClientError.new "HTTP response for #{url} was #{response.code}"
    end

    json = JSON.parse(response.body)
    if json['results']
      json['results'].map do |result|
        CreativeWork.new result
      end
    else
      nil
    end
  end
end

class CoreClientError < RuntimeError; end