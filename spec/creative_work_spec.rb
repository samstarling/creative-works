require_relative 'spec_helper'

describe CreativeWork do
  describe "parsing basic Creative Work fields" do
    before :each do
      @cw = CreativeWork.new json_fixture("creative_work/simple.json")
    end
    
    it "parses the URI" do
      @cw.uri.should == "http://www.bbc.co.uk/sport/0/winter-sports/23087674#asset"
    end
    
    it "parses the title" do
      @cw.title.should == "Winter Olympics: Bobsleigher Paula Walker in rehab on road to Sochi"
    end
    
    it "parses the short title" do
      @cw.short_title.should == "Walker in rehab on road to Sochi 2014"
    end
    
    it "parses the description" do
      @cw.description.should == "Bobsleigher Paula Walker is hopeful of recovering from a knee injury to compete in the Sochi 2014 Games."
    end
    
    it "parses the locator" do
      @cw.locator.should == ["urn:bbc:cps:asset:23087674"]
    end
    
    it "parses the created date" do
      @cw.created_date.should == DateTime.parse("2013-06-21T15:09:11Z")
    end
    
    it "parses the modified date" do
      @cw.modified_date.should == DateTime.parse("2013-06-27T15:09:11Z")
    end
    
    it "parses the web link" do
      @cw.href.should == "http://www.bbc.co.uk/sport/0/winter-sports/23087674"
    end
  end
  
  describe "parsing a more complex Creative Work" do
    before :each do
      @cw = CreativeWork.new json_fixture("creative_work/complex.json")
    end
    
    it "parses multiple locators" do
      @cw.locator.should == ["urn:bbc:cps:asset:23087674", "urn:bbc:cps:asset:1111"]
    end
    
    it "parses about tags" do
      league_two = Tag.new "League Two", "http://www.bbc.co.uk/things/71d1288c-d1ea-6a4a-bd87-237dbb9e6470#id"
      football = Tag.new "Football", "http://www.bbc.co.uk/things/ba6e1118-f874-054e-b159-b797c16e9250#id"
      @cw.about.should include league_two
      @cw.about.should include football
    end
    
    it "parses mentions tags" do
      fleetwood = Tag.new "Fleetwood Town", "http://www.bbc.co.uk/things/10ddb0dd-f49b-6d4a-a327-7f1d24805c33#id"
      football = Tag.new "Football", "http://www.bbc.co.uk/things/ba6e1118-f874-054e-b159-b797c16e9250#id"
      @cw.mentions.should include fleetwood
      @cw.mentions.should include football
    end
    
    it "returns the biggest image as the thumbnail" do
      @cw.thumbnail.should == "http://news.bbcimg.co.uk/media/images/68418000/jpg/_68418058_68417547.jpg"
    end
  end
  
  describe "handling optional fields" do
    it "handles missing thumbnails" do
      @cw = CreativeWork.new json_fixture("creative_work/no_thumbnail.json")
      @cw.thumbnail.should == nil
    end
  end
  
  describe "parsing an invalid Creative Work" do
  end
end