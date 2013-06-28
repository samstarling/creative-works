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
  
  def get_and_parse url
    response = @rest_client.get "#{@base_url}/#{url}"
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