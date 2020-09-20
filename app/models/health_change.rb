class HealthChange < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :change_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :change_date, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :health_change_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :change_name, presence: true
  
  def display
    change_name
  end

  child_files
end
