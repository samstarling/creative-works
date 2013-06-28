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
    
    it "parses the locator" do
      @cw.locator.should == ["urn:bbc:cps:asset:23087674"]
    end
    
    it "parses the created date" do
      @cw.created_date.should == DateTime.parse("2013-06-21T15:09:11Z")
    end
    
    it "parses the modified date" do
      @cw.modified_date.should == DateTime.parse("2013-06-27T15:09:11Z")
    end
  end
  
  describe "parsing a more complicated Creative Work" do
    before :each do
      @cw = CreativeWork.new json_fixture("creative_work/complex.json")
    end
    
    it "parses multiple locators" do
      @cw.locator.should == ["urn:bbc:cps:asset:23087674", "urn:bbc:cps:asset:1111"]
    end
  end
  
  describe "parsing an invalid Creative Work" do
  end
end