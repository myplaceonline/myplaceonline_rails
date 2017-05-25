class PicnicLocation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :location, presence: true
  
  def display
    location.display
  end

  child_property(name: :location)
end
