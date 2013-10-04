require_relative 'spec_helper'

describe CreativeWork do
  describe "parsing basic Creative Work fields" do
    before :each do
      @cw = CreativeWork.new json_fixture("creative_work/simple.json")
    end
    
    it "parses the URI" do
      @cw.uri.should == "http://www.bbc.co.uk/things/342759f7-46f3-4bef-99f4-62996731bb6f#id"
    end
    
    it "parses the title" do
      @cw.title.should == "Cesc Fabregas rules out move from Barcelona to England"
    end
    
    it "parses the short title" do
      @cw.short_title.should == "Fabregas rules out leaving Barcelona"
    end
    
    it "parses the description" do
      @cw.description.should == "Former Arsenal captain Cesc Fabregas dismisses speculation linking him with a move from Barcelona to an English club."
    end
    
    it "parses the locators" do
      @cw.locator.should == ["urn:asset:a02c1c41-1323-f140-a0ef-df32a0dc12b8", "urn:bbc:cps:asset:22886585"]
    end
    
    it "parses the created date" do
      @cw.created_date.should == DateTime.parse("2013-10-02T12:30:22Z")
    end
    
    it "parses the modified date" do
      @cw.modified_date.should == DateTime.parse("2013-10-02T12:30:22Z")
    end
    
    it "gives a friendly modified date" do
      @cw.friendly_modified_date.should == "12:30, 2 October 2013"
    end
    
    it "parses the web link" do
      @cw.url.should == "http://wwwpreview.stage.newsonline.tc.nca.bbc.co.uk/sport/0/football/22886585"
    end
  end
  
  describe "parsing a more complex Creative Work" do
    before :each do
      @cw = CreativeWork.new json_fixture("creative_work/complex.json")
    end
    
    it "parses about tags" do
      league_two = Tag.new json_fixture("tag/examples/league_two.json")
      football = Tag.new json_fixture("tag/examples/football.json")
      @cw.about.should include league_two
      @cw.about.should include football
    end
    
    it "parses mentions tags" do
      fleetwood = Tag.new json_fixture("tag/examples/fleetwood.json")
      football = Tag.new json_fixture("tag/examples/football.json")
      @cw.mentions.should include fleetwood
      @cw.mentions.should include football
    end
    
    it "returns the biggest image as the thumbnail" do
      @cw.thumbnail.should == "http://wwwpreview.stage.newsonline.tc.nca.bbc.co.uk/media/images/68146000/jpg/_68146859_68146858.jpg"
    end
  end
  
  describe "handling optional/complex fields" do
    it "handles missing thumbnails" do
      @cw = CreativeWork.new json_fixture("creative_work/no_thumbnail.json")
      @cw.thumbnail.should == nil
    end
    
    it "handles missing about and mentions tags" do
      @cw = CreativeWork.new json_fixture("creative_work/no_tags.json")
      @cw.about.should == nil
      @cw.mentions.should == nil
    end
    
    it "handles odd cases where tags have multiple preferredLabels" do
      @cw = CreativeWork.new json_fixture("creative_work/multiple_tag_labels.json")
      bobsleigh = Tag.new json_fixture("tag/examples/bobsleigh.json")
      @cw.about.should include bobsleigh
    end
  end
  
  describe "parsing an invalid Creative Work" do
  end
end