class Export < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :export_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :export_type, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :export_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  EXPORT_TYPE_EVERYTHING = 0

  EXPORT_TYPES = [
    ["myplaceonline.exports.export_types.everything", EXPORT_TYPE_EVERYTHING],
  ]

  EXPORT_STATUS_READY = 0
  EXPORT_STATUS_EXPORTING = 1
  EXPORT_STATUS_EXPORTED = 2
  EXPORT_STATUS_ERROR = 3
  EXPORT_STATUS_WAITING_FOR_WORKER = 4

  EXPORT_STATUSES = [
    ["myplaceonline.exports.export_statuses.ready", EXPORT_STATUS_READY],
    ["myplaceonline.exports.export_statuses.exporting", EXPORT_STATUS_EXPORTING],
    ["myplaceonline.exports.export_statuses.exported", EXPORT_STATUS_EXPORTED],
    ["myplaceonline.exports.export_statuses.error", EXPORT_STATUS_ERROR],
    ["myplaceonline.exports.export_statuses.waiting_for_worker", EXPORT_STATUS_WAITING_FOR_WORKER],
  ]
  
  COMPRESSION_TYPE_ZIP = 0
  COMPRESSION_TYPE_TAR_GZ = 1
  
  COMPRESSION_TYPES = [
    ["myplaceonline.exports.compression_types.zip", COMPRESSION_TYPE_ZIP],
    ["myplaceonline.exports.compression_types.tar_gz", COMPRESSION_TYPE_TAR_GZ],
  ]

  validates :export_name, presence: true
  validates :export_type, presence: true
  
  def display
    export_name
  end

  child_files
  
  child_property(name: :security_token)

  def export_status_display
    self.export_status.nil? ? EXPORT_STATUS_READY : self.export_status
  end
  
  def export_progress_display
    self.export_progress.blank? ? I18n.t("myplaceonline.exports.pending") : self.export_progress
  end
  
  def start
    if self.export_status != Export::EXPORT_STATUS_WAITING_FOR_WORKER && self.export_status != Export::EXPORT_STATUS_EXPORTING
      self.export_status = Export::EXPORT_STATUS_WAITING_FOR_WORKER
      self.export_progress = "* _#{User.current_user.time_now}_: Waiting for worker"
      self.save!
      
      # Always perform async because sync execution of curl doesn't work
      
      ApplicationJob.perform_async(ExportJob, self, "start")
      #ApplicationJob.perform(ExportJob, self, "start")
    end
  end

  before_create :do_before_create
  
  def do_before_create
    token = SecurityToken.build
    token.password = Myp.get_current_user_password!
    token.save!

    self.parameter = Myp.root_url
    self.security_token_id = token.id
    
    true
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.export_type = EXPORT_TYPE_EVERYTHING
    result.compression_type = COMPRESSION_TYPE_ZIP
    result.encrypt_output = true
    result
  end
end
