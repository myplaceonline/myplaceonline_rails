class Art < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :art_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :art_source, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :art_link, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :art_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :art_name, presence: true
  
  def display
    art_name
  end

  child_files
end
