class Present < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :present_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :present_given, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :present_purchased, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :present_amount, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :contact, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :present_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :present_name, presence: true
  
  def display
    present_name
  end

  child_files

  child_property(name: :contact)
end
