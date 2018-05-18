class WebsiteScraperTransformation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  TRANSFORMATION_EXTRACT1 = 0
  TRANSFORMATION_PREPEND = 1
  TRANSFORMATION_APPEND = 2

  TRANSFORMATIONS = [
    ["myplaceonline.website_scraper_transformations.transformation_extract1", TRANSFORMATION_EXTRACT1],
    ["myplaceonline.website_scraper_transformations.transformation_prepend", TRANSFORMATION_PREPEND],
    ["myplaceonline.website_scraper_transformations.transformation_append", TRANSFORMATION_APPEND],
  ]

  def self.properties
    [
      { name: :transformation_type, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :transformation, type: ApplicationRecord::PROPERTY_TYPE_TEXT },
    ]
  end

  belongs_to :website_scraper
  
  validates :transformation_type, presence: true
  
  def display
    Myp.get_select_name(self.transformation_type, WebsiteScraperTransformation::TRANSFORMATIONS)
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :transformation_type,
      :transformation,
      :position
    ]
  end
  
  def execute_transform(str)
    Rails.logger.debug{"WebsiteScraperTransformation.execute_transform Incoming type: #{self.transformation_type}, str: #{str}"}

    case self.transformation_type
    when WebsiteScraperTransformation::TRANSFORMATION_EXTRACT1
      r = Regexp.new(self.transformation, Regexp::EXTENDED | Regexp::MULTILINE)
      
      Rails.logger.debug{"WebsiteScraperTransformation.execute_transform regex: #{r}"}
      
      # Return all matches by calling String.scan and the applying the map to each match
      matches = str.to_enum(:scan, r).map { Regexp.last_match }
      
      matches = matches.map do |match|
        
        Rails.logger.debug{"WebsiteScraperTransformation.execute_transform match: #{match}"}
        
        named_captures = Myp.get_named_captures(match)
        
        item = "\n<item>\n"
        
        begin
          title = named_captures["title"]
          if !title.blank?
            item << "  <title>#{title.strip}</title>\n"
          else
            raise "Could not find title"
          end
          
          link = named_captures["link"]
          if !link.blank?
            item << "  <link>#{link.strip}</link>\n"
          else
            uniqueLink = "#{self.website_scraper.website_url}"
            if uniqueLink.include?("?")
              uniqueLink << "&"
            else
              uniqueLink << "?"
            end
            uniqueLink << "muuid=#{Digest::SHA1.hexdigest(title)}"
            item << "  <link>#{uniqueLink}</link>\n"
          end
          
          dtstr = named_captures["dateyyyymmdd"]
          if !dtstr.blank?
            date = Date.strptime(dtstr.strip, "%Y/%m/%d")
            item << "  <pubDate>#{date.rfc822}</pubDate>\n"
          end
          
          dtstr = named_captures["datedaymdatt"]
          if !dtstr.blank?
            date = DateTime.strptime(dtstr.strip, "%A, %B %d at %I:%M %p")
            item << "  <pubDate>#{date.rfc822}</pubDate>\n"
          end
        
        rescue Exception => e
          item << "  <title>Error processing transformation</title>\n"
          Myp.handle_exception(e, additional_details: named_captures.to_s)
        end
        
        item << "</item>"

        Rails.logger.debug{"WebsiteScraperTransformation.execute_transform item: #{item}"}
        
        item
      end
      
      Rails.logger.debug{"WebsiteScraperTransformation.execute_transform found #{matches.length} matches: #{matches}"}
      
      str = matches.join("\n") + "\n"
      
    when WebsiteScraperTransformation::TRANSFORMATION_PREPEND
      str = self.transformation + str
    when WebsiteScraperTransformation::TRANSFORMATION_APPEND
      str = str + self.transformation
    else
      raise "TODO"
    end

    #Rails.logger.debug{"WebsiteScraperTransformation.execute_transform Outgoing str: #{str}"}

    str
  end
end
