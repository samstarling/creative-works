require_relative 'spec_helper'

describe Tag do
  it "parses basic tag fields" do
    tag = Tag.new json_fixture("tag/simple.json")
    tag.uri.should == "http://www.bbc.co.uk/things/ba6e1118-f874-054e-b159-b797c16e9250#id"
    tag.label.should == "Football"
    tag.preferred_label.should == "Football"
    tag.short_label.should == "Football"
  end
  
  it "can tell you if it is a BBC Thing" do
    tag = Tag.new json_fixture("tag/simple.json")
    tag.is_bbc_thing?.should == true
  end
  
  it "extracts the GUID from the URI" do
    tag = Tag.new json_fixture("tag/simple.json")
    tag.guid.should == "ba6e1118-f874-054e-b159-b797c16e9250"
  end
  
  it "has a string representation" do
    tag = Tag.new json_fixture("tag/simple.json")
    tag.to_s.should == "Football"
  end
end
  