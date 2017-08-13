class Import < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :import_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :import_type, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :import_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  IMPORT_TYPE_MEDIAWIKI = 0

  IMPORT_TYPES = [
    ["myplaceonline.imports.import_types.mediawiki", IMPORT_TYPE_MEDIAWIKI],
  ]

  validates :import_name, presence: true
  validates :import_type, presence: true
  
  def display
    import_name
  end

  child_files
end
