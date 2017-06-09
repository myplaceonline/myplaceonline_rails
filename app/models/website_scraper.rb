class WebsiteScraper < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  CONTENT_TYPES = [
    ["text/html", "text/html"],
    ["application/rss+xml", "application/rss+xml"],
  ]

  def self.properties
    [
      { name: :scraper_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :website_url, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  validates :scraper_name, presence: true
  validates :website_url, presence: true
  
  def display
    scraper_name
  end

  child_properties(name: :website_scraper_transformations, sort: "position ASC")
end
