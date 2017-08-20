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

  IMPORT_STATUS_READY = 0
  IMPORT_STATUS_IMPORTING = 1
  IMPORT_STATUS_IMPORTED = 2

  IMPORT_STATUSES = [
    ["myplaceonline.imports.import_statuses.ready", IMPORT_STATUS_READY],
    ["myplaceonline.imports.import_statuses.importing", IMPORT_STATUS_IMPORTING],
    ["myplaceonline.imports.import_statuses.imported", IMPORT_STATUS_IMPORTED],
  ]

  validates :import_name, presence: true
  validates :import_type, presence: true
  
  def display
    import_name
  end

  child_files
  
  def import_status_display
    self.import_status.nil? ? IMPORT_STATUS_READY : self.import_status
  end
  
  def import_progress_display
    self.import_progress.blank? ? I18n.t("myplaceonline.imports.pending") : self.import_progress
  end
end
