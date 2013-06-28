require_relative 'spec_helper'

describe JSONHelper do
  describe "normalise_array" do
    it "turns hashes into a single-item array" do
      normalised = JSONHelper.normalise_array({:foo => 123})
      normalised.should == [{:foo => 123}]
    end
    
    it "leaves arrays alone" do
      normalised = JSONHelper.normalise_array([1, 2, 3])
      normalised.should == [1, 2, 3]
    end
  end
end
  
