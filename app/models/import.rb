class Import < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :import_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :import_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :import_name, presence: true
  
  def display
    import_name
  end

  child_files
end
