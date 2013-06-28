require_relative 'spec_helper'

describe JSONHelper do
  describe "normalize_array" do
    it "turns hashes into a single-item array" do
      normalised = JSONHelper.normalize_array({:foo => 123})
      normalised.should == [{:foo => 123}]
    end
    
    it "leaves arrays alone" do
      normalised = JSONHelper.normalize_array([1, 2, 3])
      normalised.should == [1, 2, 3]
    end
  end
end
  
