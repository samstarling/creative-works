require_relative 'json_helper'

class TagConcept
  def initialize json
    @json = json
  end
  
  def uri
    @json['@id']
  end
  
  def type
    JSONHelper.normalize_array(@json['@type'])
  end
  
  def label
    @json['label']
  end
end