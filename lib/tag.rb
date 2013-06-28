class Tag
  attr_reader :title, :uri
  
  def initialize title, uri
    @title = title
    @uri = uri
  end
  
  def is_bbc_thing?
    @uri.start_with? "http://www.bbc.co.uk/things/"
  end
  
  def to_s
    @title
  end
  
  def == other
    @title == other.title
    @uri == other.uri
  end
end