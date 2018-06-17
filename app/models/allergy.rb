class Allergy < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :allergy_description, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :started, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :ended, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :allergy_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :allergy_description, presence: true
  
  def display
    allergy_description
  end

  child_files
end
