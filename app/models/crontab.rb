class Crontab < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :crontab_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :dblocker, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :run_class, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :run_method, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :minutes, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :last_success, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :run_data, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  validates :crontab_name, presence: true
  
  def display
    crontab_name
  end
end
