require 'date'

require_relative 'tag'
require_relative 'json_helper'

class CreativeWork
  def initialize json
    @json = json
  end
  
  def uri
    @json['@id']
  end
  
  def title
    @json['title']
  end
  
  def short_title
    @json['shortTitle']
  end
  
  def description
    @json['description']
  end
  
  def href
    @json['primaryContentOf']
  end
  
  def locator
    JSONHelper.normalize_array(@json['locator'])
  end
  
  def created_date
    DateTime.parse(@json['dateCreated'])
  end
  
  def modified_date
    DateTime.parse(@json['dateModified'])
  end
  
  def thumbnail
    if @json['thumbnail']
      thumbnails = @json['thumbnail'].select do |thumb|
        thumb['thumbnailType'] == "FixedSize464Thumbnail"
      end
      JSONHelper.normalize_array(thumbnails).first['@id'].gsub("#image", "")
    else
      nil
    end
  end
  
  def about
    tag 'about'
  end
  
  def mentions
    tag 'mentions'
  end
  
  private
  
  def tag type
    if @json[type]
      tags = JSONHelper.normalize_array(@json[type])
      tags.map do |tag|
        Tag.new tag
      end
    else
      nil
    end
  end
end