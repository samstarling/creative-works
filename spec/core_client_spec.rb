require_relative 'spec_helper'

describe CoreClient do
  before :each do
    @rest_client = double("RestClient")
    @base_url = "http://foo"
    @core_client = CoreClient.new "foo", @rest_client, @base_url
  end
  
  def mock_response body, code=200
    response = double("Response")
    response.stub(:body) { body }
    response.stub(:code) { code }
    @rest_client.stub(:get) { response }
  end
  
  describe "tag concepts" do
    before :each do
      mock_response fixture("core_client/tag_concepts/list.json")
    end
    
    it "fetches a list of TagConcepts for a search query" do
      @rest_client.should_receive(:get).with("#{@base_url}/tag-concepts?search=Munst&legacy=true&api_key=foo")
      @core_client.tag_concepts({search: "Munst", legacy: true})
    end
  end
  
  describe "creative_works" do
    before :each do
      mock_response fixture("core_client/creative_works/latest.json")
    end
    
    it "fetches the latest legacy Creative Works by default" do
      @rest_client.should_receive(:get).with("#{@base_url}/creative-works?legacy=true&api_key=foo")
      @core_client.creative_works
    end
    
    it "fetches non-legacy Creative Works" do
      @rest_client.should_receive(:get).with("#{@base_url}/creative-works?legacy=false&api_key=foo")
      @core_client.creative_works({ legacy: false })
    end
    
    it "fetches Creative Works about a GUID" do
      @rest_client.should_receive(:get).with("#{@base_url}/creative-works?legacy=true&about=donkeys&api_key=foo")
      @core_client.creative_works({ legacy: true, about: "donkeys" })
    end
    
    it "produces the correct number of Creative Works" do
      creative_works = @core_client.creative_works
      creative_works.size.should == 10
    end
    
    it "returns CreativeWork objects" do
      creative_works = @core_client.creative_works
      creative_works.first.class.should == CreativeWork
    end
    
    it "returns nil when the response is empty" do
      mock_response "{}"
      @core_client.creative_works.should == nil
    end
    
    it "throws an exception for non-200 response codes" do
      mock_response "Fail", 500
      expect { @core_client.creative_works }.to raise_error(CoreClientError)
    end
  end
end