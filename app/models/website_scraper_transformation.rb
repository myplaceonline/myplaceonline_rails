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
      matches = str.to_enum(:scan, r).map { Regexp.last_match }
      matches = matches.map do |match|
        #Rails.logger.debug{"WebsiteScraperTransformation.execute_transform match: #{match}"}
        link = match[:link]
        title = match[:title]
        dateyyyymmdd = match[:dateyyyymmdd]
        date = Date.strptime(dateyyyymmdd, "%Y/%m/%d")
%{
<item>
  <title>#{title}</title>
  <link>#{link}</link>
  <pubDate>#{date.rfc822}</pubDate>
</item>
}
      end
      str = matches.join("\n")
    when WebsiteScraperTransformation::TRANSFORMATION_PREPEND
      str = self.transformation + str
    when WebsiteScraperTransformation::TRANSFORMATION_APPEND
      str = str + self.transformation
    else
      raise "TODO"
    end

    Rails.logger.debug{"WebsiteScraperTransformation.execute_transform Outgoing str: #{str}"}

    str
  end
end
