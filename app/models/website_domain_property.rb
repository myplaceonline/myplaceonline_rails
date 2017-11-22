class WebsiteDomainProperty < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :property_key, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :property_value, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  belongs_to :website_domain
  
  validates :property_key, presence: true
  
  def display
    self.property_key
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :property_key,
      :property_value,
    ]
  end
end
