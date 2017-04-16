class InsuranceCard < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :insurance_card_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :insurance_card_start, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :insurance_card_end, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :insurance_card_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :insurance_card_name, presence: true
  
  def display
    insurance_card_name
  end

  child_files
end
