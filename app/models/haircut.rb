class Haircut < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :haircut_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :total_cost, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :cutter, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :haircut_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :haircut_time, presence: true
  
  def display
    Myp.display_datetime_short_year(haircut_time, User.current_user)
  end

  child_files

  child_property(name: :location)

  child_property(name: :cutter, model: Contact)
end
