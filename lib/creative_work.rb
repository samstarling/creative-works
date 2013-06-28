require 'date'

require_relative 'tag'

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
    [@json['locator'], ].flatten
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
      # TODO Add a test to cover this
      # TODO Factor out to separate class
      if thumbnails.class == Array
        thumbnails.first['@id'].gsub("#image", "")
      elsif thumbnails.class == String
        thumbnails
      else
        nil
      end
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
    @json[type].map do |tag|
      Tag.new tag['preferredLabel'], tag['@id']
    end
  end
end