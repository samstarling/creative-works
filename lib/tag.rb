require_relative 'json_helper'

class Tag
  attr_reader :uri
  
  def initialize json
    @json = json
  end
  
  def uri
    @json['@id']
  end
  
  def title
    preferred_label || label || short_label
  end
  
  def label
    attribute_safe("shortLabel").first
  end
  
  def preferred_label
    attribute_safe("preferredLabel").first
  end
  
  def short_label
    attribute_safe("shortLabel").first
  end
  
  def is_bbc_thing?
    uri.start_with? "http://www.bbc.co.uk/things/"
  end
  
  def to_s
    "#{title}"
  end
  
  def == other
    uri == other.uri
  end
  
  private
  
  def attribute_safe name
    JSONHelper.normalize_array(@json[name])
  end
end