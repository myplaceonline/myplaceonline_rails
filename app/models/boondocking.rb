class Boondocking < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :camp_location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  def display
    self.camp_location.display
  end

  child_property(name: :camp_location, required: true)
end
