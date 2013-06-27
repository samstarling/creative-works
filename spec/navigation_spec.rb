require_relative 'spec_helper'

describe Navigation do
  it "should provide an array of Navigation Items" do
    nav = Navigation.new({ tennis: "/tennis" })
    nav_item = NavigationItem.new :tennis, "/tennis"
    nav.items.should == [nav_item]
  end
end