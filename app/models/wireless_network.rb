class WirelessNetwork < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :network_names, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :password, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :network_names, presence: true
  
  def display
    network_names
  end

  child_property(name: :location)
  child_property(name: :password)
end
