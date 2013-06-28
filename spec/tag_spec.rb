require_relative 'spec_helper'

describe Tag do
  it "can tell you if it is a BBC Thing" do
    tag = Tag.new "Football", "http://www.bbc.co.uk/things/ba6e1118-f874-054e-b159-b797c16e9250#id"
    tag.is_bbc_thing?.should == true
  end
  
  it "has a string representation" do
    tag = Tag.new "Football", "http://www.bbc.co.uk/things/ba6e1118-f874-054e-b159-b797c16e9250#id"
    tag.to_s.should == "Football"
  end
end
  