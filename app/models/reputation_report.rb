class ReputationReport < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :short_description, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :story, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :report_status, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :reputation_report_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  REPORT_STATUS_PENDING_REVIEW = 0

  REPORT_STATUSES = [
    ["myplaceonline.reputation_reports.report_statuses.pending_review", REPORT_STATUS_PENDING_REVIEW],
  ]

  validates :short_description, presence: true
  validates :story, presence: true
  
  def display
    short_description
  end

  child_files
  
  def report_status_s
    Myp.get_select_name(self.processed_report_status, REPORT_STATUSES)
  end
  
  def processed_report_status
    result = self.report_status
    if result.nil?
      result = REPORT_STATUS_PENDING_REVIEW
    end
    result
  end
end
