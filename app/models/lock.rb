class Lock < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :lock_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :password, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :lock_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :lock_name, presence: true
  
  def display
    lock_name
  end

  child_files

  child_property(name: :location)
  child_property(name: :password)
end
