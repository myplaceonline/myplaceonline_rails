class Diet < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :diet_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :dietary_requirements_collection, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :diet_name, presence: true
  
  def display
    diet_name
  end

  child_property(name: :dietary_requirements_collection)
end
