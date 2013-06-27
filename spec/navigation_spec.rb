require_relative 'spec_helper'

describe Navigation do
  it "should return all items" do
    nav_item = NavigationItem.new "Tennis", "/tennis"
    nav = Navigation.new([nav_item])
    nav.items.should == [nav_item]
  end
  
  it "should return items in their correct order" do
    first_item = NavigationItem.new "Tennis", "/tennis", 1
    second_item = NavigationItem.new "Football", "/football", 2
    nav = Navigation.new([second_item, first_item])
    nav.items.should == [first_item, second_item]
  end
end