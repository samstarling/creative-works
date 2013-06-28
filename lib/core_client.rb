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
    
  def creative_works params = { legacy: false }
    param_array = params.map { |k, v| "#{k}=#{v}" }
    param_string = param_array.join("&")
    get_creative_works "creative-works?#{param_string}&api_key=#{@api_key}"
  end
  
  private
  
  def get_creative_works path
    json = safe_get_json path
    if json['results']
      json['results'].map do |result|
        CreativeWork.new result
      end
    else
      nil
    end
  end
  
  def safe_get_json path
    url = "#{@base_url}/#{path}"
    response = @rest_client.get url

    if response.code != 200
      raise CoreClientError.new "HTTP response for #{url} was #{response.code}"
    end
    
    JSON.parse(response.body)
  end
end

class CoreClientError < RuntimeError; end