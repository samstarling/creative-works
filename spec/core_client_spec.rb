require_relative 'spec_helper'

describe CoreClient do
  before :each do
    @rest_client = double("RestClient")
    mock_response "{}"
    @base_url = "http://foo"
    @core_client = CoreClient.new @rest_client, @base_url
  end
  
  def mock_response body
    response = double("Response")
    response.stub(:body) { body }
    @rest_client.stub(:get) { response }
  end
  
  describe "creative_works" do
    it "fetches with no arguments" do
      @rest_client.should_receive(:get).with("#{@base_url}/creative-works")
      @core_client.creative_works
    end
    
    it "parses the returned JSON correctly" do
      mock_response fixture("core_client/latest.json")
      creative_works = @core_client.creative_works
      creative_works.size.should == 10
    end
  end
end