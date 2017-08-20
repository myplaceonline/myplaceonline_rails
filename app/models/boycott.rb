class Boycott < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :boycott_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :boycott_start, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  validates :boycott_name, presence: true
  
  def display
    boycott_name
  end
end
