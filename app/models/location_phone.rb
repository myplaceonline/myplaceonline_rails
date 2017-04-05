class LocationPhone < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  def self.properties
    [
      { name: :number, type: ApplicationRecord::PROPERTY_TYPE_STRING },
    ]
  end
  
  belongs_to :location
end
