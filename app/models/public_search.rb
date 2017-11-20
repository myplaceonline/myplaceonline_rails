class PublicSearch < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :category, type: ApplicationRecord::PROPERTY_TYPE_STRING },
    ]
  end

  validates :category, presence: true
  
  def display
    category
  end
end
