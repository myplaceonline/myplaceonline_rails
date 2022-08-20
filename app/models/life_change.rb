class LifeChange < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :life_change_title, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :start_day, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :end_day, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :life_change_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :life_change_title, presence: true
  
  def display
    life_change_title
  end

  child_files
end
