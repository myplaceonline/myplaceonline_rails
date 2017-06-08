class WebsiteScraperTransformation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  TRANSFORMATION_EXTRACT = 0

  TRANSFORMATIONS = [
    ["myplaceonline.website_scraper_transformations.transformation_extract", TRANSFORMATION_EXTRACT],
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
end
