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
  
  def url
    poten = JSONHelper.normalize_array(@json['primaryContentOf'])
    non_mobile_urls = poten.select { |u| u.include?("mobile") == false }

    if non_mobile_urls
      non_mobile_urls.first
    else
      urls.first
    end
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
  
  def friendly_modified_date
    modified_date.strftime("%H:%M, %e %B %Y")
  end
  
  def thumbnail
    if @json['thumbnail']
      thumbnails = @json['thumbnail'].select do |thumb|
        thumb['thumbnailType'] == "FixedSize464Thumbnail"
      end
      puts JSONHelper.normalize_array(thumbnails)
      if JSONHelper.normalize_array(thumbnails).first
        JSONHelper.normalize_array(thumbnails).first['@id'].gsub("#image", "")
      end
    end
  end
  
  def about
    tag('about')
  end
  
  def mentions
    tag('mentions')
  end
  
  private
  
  def tag type
    if @json[type]
      tags = JSONHelper.normalize_array(@json[type])
      new_tags = tags.map do |tag|
        if tag['@id']
          Tag.new tag
        end
      end
      new_tags.select { |t| nil != t }
    else
      nil
    end
  end
end