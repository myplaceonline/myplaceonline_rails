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
  REPORT_STATUS_PENDING_INITIAL_DECISION_REVIEW = 3
  REPORT_STATUS_PUBLISHED = 4
  REPORT_STATUS_PENDING_FINAL_PAYMENT_FROM_USER = 5
  REPORT_STATUS_UNPUBLISHED = 6

  REPORT_STATUSES = [
    ["myplaceonline.reputation_reports.report_statuses.pending_review", REPORT_STATUS_PENDING_REVIEW],
    ["myplaceonline.reputation_reports.report_statuses.pending_payment_from_user", REPORT_STATUS_PENDING_PAYMENT_FROM_USER],
    ["myplaceonline.reputation_reports.report_statuses.site_investigating", REPORT_STATUS_SITE_INVESTIGATING],
    ["myplaceonline.reputation_reports.report_statuses.pending_initial_decision_review", REPORT_STATUS_PENDING_INITIAL_DECISION_REVIEW],
    ["myplaceonline.reputation_reports.report_statuses.published", REPORT_STATUS_PUBLISHED],
    ["myplaceonline.reputation_reports.report_statuses.pending_final_payment_from_user", REPORT_STATUS_PENDING_FINAL_PAYMENT_FROM_USER],
    ["myplaceonline.reputation_reports.report_statuses.unpublished", REPORT_STATUS_UNPUBLISHED],
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
      self.send_admin_message(subject: "New Reputation Report", body_markdown: "[#{link}](#{link})")
    end
  end
  
  def read_only?(action: nil)
    result = true
    
    if !self.report_status.nil?
      
      if action == :request_status
        result = false
      end
      
      if self.report_status == REPORT_STATUS_PENDING_INITIAL_DECISION_REVIEW && action == :review
        result = false
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
  
  def waiting_for_payment?
    !self.report_status.nil? && self.report_status == REPORT_STATUS_PENDING_PAYMENT_FROM_USER
  end
  
  def paid(site_invoice)
    
    if self.report_status == ReputationReport::REPORT_STATUS_PENDING_PAYMENT_FROM_USER
      self.report_status = ReputationReport::REPORT_STATUS_SITE_INVESTIGATING
      self.save!
      
      link = reputation_report_url(self)
      self.send_admin_message(subject: "Reputation Report Paid", body_markdown: "[#{link}](#{link})")
    elsif self.report_status == ReputationReport::REPORT_STATUS_PENDING_FINAL_PAYMENT_FROM_USER
      self.publish
    end
    
    {
      redirect_path: reputation_report_path(self)
    }
  end
  
  def get_site_invoice
    SiteInvoice.where(model_class: self.model_name.name, model_id: self.id).take
  end
  
  def send_reporter_message(subject:, body_short_markdown:, body_long_markdown:)
    long_signature = Myp.website_domain_property("long_signature")
    if !long_signature.blank?
      body_long_markdown += long_signature
    end
    short_signature = Myp.website_domain_property("short_signature")
    if !short_signature.blank?
      body_short_markdown += short_signature
    end
    self.identity.send_message(body_short_markdown, body_long_markdown, subject, bcc: User.current_user.email)
  end
  
  def send_admin_message(subject:, body_markdown:)
    body_html = Myp.markdown_to_html(body_markdown)
    Myp.send_support_email_safe(
      subject,
      body_html,
      body_markdown,
      request: MyplaceonlineExecutionContext.request,
      html_comment_details: true
    )
  end
  
  def publish
    link = reputation_report_url(self)
    self.send_admin_message(subject: "Reputation Report Fully Paid and Published", body_markdown: "[#{link}](#{link})")
    
    self.change_permissions(true)
  end
  
  def unpublish
    self.change_permissions(false)
  end
  
  def change_permissions(is_public)
    ActiveRecord::Base.transaction do
      if is_public
        self.report_status = ReputationReport::REPORT_STATUS_PUBLISHED
      else
        self.report_status = ReputationReport::REPORT_STATUS_UNPUBLISHED
      end
      self.is_public = is_public
      self.save!

      if is_public || (!is_public && self.agent.public_reputation_reports.count == 0)
        self.agent.is_public = is_public
        self.agent.save!
        
        self.agent.agent_identity.is_public = is_public
        self.agent.agent_identity.save!
      end
    end
  end
end
