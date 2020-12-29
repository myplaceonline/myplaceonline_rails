class AirlineProgram < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :program_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :status, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :password, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :membership, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :program_name, presence: true
  
  def display
    program_name
  end

  child_property(name: :password)

  child_property(name: :membership)
end
