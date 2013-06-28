require 'json'

class CoreClient
  def initialize rest_client
    @rest_client = rest_client
  end
    
  def creative_works
    get_and_parse "foo"
  end
  
  private
  
  def get_and_parse url
    response = @rest_client.get url
    json = JSON.parse(response.body)
    json['results']
  end
end