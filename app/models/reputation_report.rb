class ReputationReport < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include Rails.application.routes.url_helpers

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
  REPORT_STATUS_PENDING_PAYMENT_FROM_USER = 1
  REPORT_STATUS_SITE_INVESTIGATING = 2

  REPORT_STATUSES = [
    ["myplaceonline.reputation_reports.report_statuses.pending_review", REPORT_STATUS_PENDING_REVIEW],
    ["myplaceonline.reputation_reports.report_statuses.pending_payment_from_user", REPORT_STATUS_PENDING_PAYMENT_FROM_USER],
    ["myplaceonline.reputation_reports.report_statuses.site_investigating", REPORT_STATUS_SITE_INVESTIGATING],
  ]

  REPORT_TYPE_PRAISE = 0
  REPORT_TYPE_SHAME = 1

  REPORT_TYPES = [
    ["myplaceonline.reputation_reports.report_types.shame", REPORT_TYPE_SHAME],
    ["myplaceonline.reputation_reports.report_types.praise", REPORT_TYPE_PRAISE],
  ]

  validates :short_description, presence: true
  validates :story, presence: true
  validates :report_type, presence: true
  
  def display
    short_description
  end

  child_files
  
  child_property(name: :agent, required: true)

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
  
  after_commit :on_after_create, on: [:create]

  def on_after_create
    
    if self.report_status.nil?
      link = reputation_report_url(self)
      body_plain = "[#{link}](#{link})"
      body_html = Myp.markdown_to_html(body_plain)
      
      Myp.send_support_email_safe(
        "New Reputation Report",
        body_html,
        body_plain,
        request: MyplaceonlineExecutionContext.request,
        html_comment_details: true
      )
    end
  end
  
  def read_only?(action: nil)
    result = false
    
    if !self.report_status.nil? || self.report_status == REPORT_STATUS_PENDING_PAYMENT_FROM_USER ||
        self.report_status == REPORT_STATUS_SITE_INVESTIGATING
       
      if action != :request_status
        result = true
      end
    end
    
    if User.current_user.admin?
      result = false
    end
    
    result
  end
  
  def allow_admin?
    true
  end
  
  def paid(site_invoice)
    
    if self.report_status == ReputationReport::REPORT_STATUS_PENDING_PAYMENT_FROM_USER
      self.report_status = ReputationReport::REPORT_STATUS_SITE_INVESTIGATING
      self.save!

      link = reputation_report_url(self)
      body_plain = "[#{link}](#{link})"
      body_html = Myp.markdown_to_html(body_plain)
      
      Myp.send_support_email_safe(
        "Reputation Report Paid",
        body_html,
        body_plain,
        request: MyplaceonlineExecutionContext.request,
        html_comment_details: true
      )
    end
    
    {
      redirect_path: reputation_report_path(self)
    }
  end
end
