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
  IMPORT_TYPE_WORDPRESS = 1
  IMPORT_TYPE_23ANDMEDNA = 2

  IMPORT_TYPES = [
    ["myplaceonline.imports.import_types.mediawiki", IMPORT_TYPE_MEDIAWIKI],
    ["myplaceonline.imports.import_types.wordpress", IMPORT_TYPE_WORDPRESS],
    ["myplaceonline.imports.import_types.23andmedna", IMPORT_TYPE_23ANDMEDNA],
  ]

  IMPORT_STATUS_READY = 0
  IMPORT_STATUS_IMPORTING = 1
  IMPORT_STATUS_IMPORTED = 2
  IMPORT_STATUS_ERROR = 3
  IMPORT_STATUS_WAITING_FOR_WORKER = 4

  IMPORT_STATUSES = [
    ["myplaceonline.imports.import_statuses.ready", IMPORT_STATUS_READY],
    ["myplaceonline.imports.import_statuses.importing", IMPORT_STATUS_IMPORTING],
    ["myplaceonline.imports.import_statuses.imported", IMPORT_STATUS_IMPORTED],
    ["myplaceonline.imports.import_statuses.error", IMPORT_STATUS_ERROR],
    ["myplaceonline.imports.import_statuses.waiting_for_worker", IMPORT_STATUS_WAITING_FOR_WORKER],
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
  
  def start
    if self.import_status != Import::IMPORT_STATUS_WAITING_FOR_WORKER
      self.import_status = Import::IMPORT_STATUS_WAITING_FOR_WORKER
      self.import_progress = "* _#{User.current_user.time_now}_: Waiting for worker"
      self.save!
      ApplicationJob.perform(ImportJob, self, "start")
    end
  end
end
