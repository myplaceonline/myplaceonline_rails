class Boycott < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :boycott_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :boycott_start, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :boycott_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :boycott_name, presence: true
  
  child_files
  
  def display
    boycott_name
  end
end
