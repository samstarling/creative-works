require_relative 'spec_helper'

describe Navigation do
  it "returns all items" do
    nav_item = NavigationItem.new "Tennis", "/tennis"
    nav = Navigation.new([nav_item])
    nav.items.should == [nav_item]
  end
  
  it "returns items in their correct order" do
    first_item = NavigationItem.new "Tennis", "/tennis", 1
    second_item = NavigationItem.new "Football", "/football", 2
    nav = Navigation.new([second_item, first_item])
    nav.items.should == [first_item, second_item]
  end
end

describe NavigationItem do
  it "is deemed active when the request path matches" do
    request = double("Request")
    request.stub(:path) { "/tennis" }
    nav_item = NavigationItem.new "Tennis", "/tennis"
    result = nav_item.active_for? request
    result.should == true
  end
end