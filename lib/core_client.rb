require 'json'

class CoreClient
  def initialize rest_client, base_url
    @rest_client = rest_client
    @base_url = base_url
  end
    
  def creative_works
    get_and_parse "creative-works"
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