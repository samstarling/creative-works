require 'date'

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
    thumbnails = @json['thumbnail'].select do |thumb|
      thumb['thumbnailType'] == "FixedSize464Thumbnail"
    end
    thumbnails.first['@id'].gsub("#image", "")
  end
end