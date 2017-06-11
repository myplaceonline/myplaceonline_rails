class Regimen < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :regimen_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :regimen_items, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end

  validates :regimen_name, presence: true
  
  def display
    regimen_name
  end

  child_properties(name: :regimen_items, sort: "position ASC")
end
