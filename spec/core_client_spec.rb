require_relative 'spec_helper'

describe CoreClient do
  before :each do
    @rest_client = double("RestClient")
    mock_response fixture("core_client/latest.json")
    @base_url = "http://foo"
    @core_client = CoreClient.new @rest_client, @base_url
  end
  
  def mock_response body
    response = double("Response")
    response.stub(:body) { body }
    @rest_client.stub(:get) { response }
  end
  
  describe "creative_works" do
    it "fetches the latest Creative Works by default" do
      @rest_client.should_receive(:get).with("#{@base_url}/creative-works")
      @core_client.creative_works
    end
    
    it "produces the correct number of Creative Works" do
      creative_works = @core_client.creative_works
      creative_works.size.should == 10
    end
    
    it "returns CreativeWork objects" do
      creative_works = @core_client.creative_works
      creative_works.first.class.should == CreativeWork
    end
  end
end