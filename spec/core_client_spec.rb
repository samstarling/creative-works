require_relative 'spec_helper'

describe CoreClient do
  before :each do
    @rest_client = double("RestClient")
    @core_client = CoreClient.new @rest_client
  end
  
  def mock_response
    response = double("Response")
    response.stub(:body) { fixture("core_client/latest.json") }
    @rest_client.stub(:get) { response }
  end
  
  describe "creative_works" do
    it "fetches lists of creative works" do
      mock_response
      @core_client.creative_works.size.should == 10
    end
  end
end