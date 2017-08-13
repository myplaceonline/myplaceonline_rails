class Beach < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :crowded, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end
  
  def display
    location.display
  end

  child_property(name: :location, required: true)

  def self.skip_check_attributes
    ["crowded"]
  end
end
