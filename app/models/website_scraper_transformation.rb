class WebsiteScraperTransformation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  TRANSFORMATION_EXTRACT1 = 0

  TRANSFORMATIONS = [
    ["myplaceonline.website_scraper_transformations.transformation_extract1", TRANSFORMATION_EXTRACT1],
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
    case self.transformation_type
    when WebsiteScraperTransformation::TRANSFORMATION_EXTRACT1
      r = Regexp.new(self.transformation, Regexp::EXTENDED | Regexp::MULTILINE)
      Rails.logger.debug{"WebsiteScraperTransformation.execute_transform regex: #{r}"}
      matches = str.to_enum(:scan, r).map { Regexp.last_match }
      matches = matches.map do |match|
        Rails.logger.debug{"WebsiteScraperTransformation.execute_transform match: #{match}"}
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
    else
      raise "TODO"
    end
    str
  end
end
