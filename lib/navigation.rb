class Navigation
  attr_reader :items
  
  def initialize data
    @items = data.map do |title, path|
      NavigationItem.new title, path
    end
  end
end

class NavigationItem
  attr_reader :title, :path
  
  def initialize title, path
    @title = title
    @path = path
  end
  
  def ==(other)
    @title == other.title
    @path == other.path
  end
end