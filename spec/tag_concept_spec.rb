require_relative 'spec_helper'

describe TagConcept do
  it "parses basic tag concept fields" do
    tag_concept = TagConcept.new json_fixture("tag_concept/no_label.json")
    tag_concept.uri.should == "http://sws.geonames.org/3333203/"
    tag_concept.type.should == ["Thing", "TagConcept"]
    tag_concept.label.should == nil
  end
  
  it "parses tag concepts with labels" do
    tag_concept = TagConcept.new json_fixture("tag_concept/simple.json")
    tag_concept.label.should == "Stoke v Liverpool"
  end
  
  it "parses GUIDs when possible" do
    tag_concept = TagConcept.new json_fixture("tag_concept/bbc_concept.json")
    tag_concept.uri.should == "http://www.bbc.co.uk/things/4bdbf21d-d1ad-7147-ab08-612cd0dc20b4#id"
    tag_concept.guid.should == "4bdbf21d-d1ad-7147-ab08-612cd0dc20b4"
  end
end