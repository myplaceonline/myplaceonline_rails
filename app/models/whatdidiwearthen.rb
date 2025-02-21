class Whatdidiwearthen < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :weartime, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :test_object_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :weartime, presence: true
  
  def display
    Myp.display_datetime(weartime, User.current_user)
  end

  child_files
  child_properties(name: :whatdidiwearthen_contacts)
  child_properties(name: :whatdidiwearthen_locations)
end
