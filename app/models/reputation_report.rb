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
  
  child_properties(name: :reputation_report_messages, sort: "updated_at DESC")

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
      
      if action == :request_status || action == :mediation || action == :accusations
        result = false
      end
      
      if self.report_status == REPORT_STATUS_PENDING_INITIAL_DECISION_REVIEW && action == :review
        result = false
      end
      
      if self.report_status == REPORT_STATUS_PENDING_REVIEW
        result = false
      end

    else
      result = false
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
    
    message = nil
    if self.report_status == ReputationReport::REPORT_STATUS_PENDING_PAYMENT_FROM_USER
      self.report_status = ReputationReport::REPORT_STATUS_SITE_INVESTIGATING
      self.save!
      
      link = reputation_report_url(self)
      self.send_admin_message(subject: "Reputation Report Paid", body_markdown: "[#{link}](#{link})")
    elsif self.report_status == ReputationReport::REPORT_STATUS_PENDING_FINAL_PAYMENT_FROM_USER
      self.publish
      message = I18n.t("myplaceonline.reputation_reports.approved_message")
    end
    
    {
      redirect_path: reputation_report_path(self),
      message: message,
    }
  end
  
  def get_site_invoice
    SiteInvoice.where(model_class: self.model_name.name, model_id: self.id).take
  end
  
  def send_reporter_message(subject:, body_short_markdown:, body_long_markdown:)
    send_from_admin_message(
      contact: self.identity.ensure_contact!,
      subject: subject,
      body_short_markdown: body_short_markdown,
      body_long_markdown: body_long_markdown
    )
  end
  
  def send_accused_message(subject:, body_short_markdown:, body_long_markdown:)
    send_from_admin_message(
      contact: self.ensure_agent_contact,
      subject: subject,
      body_short_markdown: body_short_markdown,
      body_long_markdown: body_long_markdown
    )
  end
  
  def send_from_admin_message(contact:, subject:, body_short_markdown:, body_long_markdown:)
    suppress_signature = false

    long_signature = Myp.website_domain_property("long_signature")
    if !long_signature.blank?
      body_long_markdown += "\n\n" + long_signature
      suppress_signature = true
    end

    short_signature = Myp.website_domain_property("short_signature")
    if !short_signature.blank?
      body_short_markdown += " (" + short_signature + ")"
      suppress_signature = true
    end
    
    ActiveRecord::Base.transaction do
      
      message = Message.create!(
        identity: self.identity,
        body: body_short_markdown,
        long_body: body_long_markdown,
        send_preferences: Message::SEND_PREFERENCE_DEFAULT,
        message_category: Myp.website_domain.display,
        subject: subject,
        suppress_signature: suppress_signature,
        reply_to: User.current_user.domain_identity.user.email,
        suppress_context_info: true,
        message_contacts: [
          MessageContact.new(
            identity: self.identity,
            contact: contact,
          )
        ]
      )
      
      ReputationReportMessage.create!(
        identity: self.identity,
        reputation_report: self,
        message: message,
      )
      
      message.process
    end
    
    #self.identity.send_message(body_short_markdown, body_long_markdown, subject, bcc: User.current_user.email)
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
    
    if is_public
      link = agent_alias_url(self.agent)
      subject = I18n.t(
        "myplaceonline.reputation_reports.published_subject",
        type: self.report_type_s,
        name: self.agent.display,
      )
      message = I18n.t(
        "myplaceonline.reputation_reports.published",
        type: self.report_type_s,
        name: self.agent.display,
        link: link,
      )
      
      self.send_reporter_message(
        subject: subject,
        body_short_markdown: message,
        body_long_markdown: message
      )
    end
  end
  
  def report_type_s
    Myp.get_select_name(self.report_type, REPORT_TYPES)
  end

  def ensure_agent_contact
    contact = Contact.where(contact_identity_id: self.agent.agent_identity_id).take
    if contact.nil?
      ActiveRecord::Base.transaction do
        contact = Contact.create!(
          identity: self.identity,
          contact_identity_id: self.agent.agent_identity_id,
        )
        
        Permission.create!(
          action: Permission::ACTION_MANAGE,
          subject_class: Contact.name.underscore.pluralize,
          subject_id: contact.id,
          identity_id: User.current_user.domain_identity,
          user_id: User.current_user.id,
        )
      end
    end
    contact
  end

  def self.skip_check_attributes
    ["allow_mediation"]
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.allow_mediation = true
    result
  end
  
  def public_mediation_link
    existing_permission_share = PermissionShare.includes(:share).where(
      subject_class: self.class.name,
      subject_id: self.id,
      valid_guest_actions: "mediation",
    ).first
    
    if existing_permission_share.nil?
      share = Share.build_share(owner_identity: self.identity)
      share.save!
      
      PermissionShare.create!(
        identity_id: self.identity_id,
        share: share,
        subject_class: self.class.name,
        subject_id: self.id,
        valid_guest_actions: "mediation",
      )
      
      token = share.token
    else
      token = existing_permission_share.share.token
    end
    reputation_report_mediation_url(self, token: token)
  end

  def public_accusations_link
    existing_permission_share = PermissionShare.includes(:share).where(
      subject_class: self.class.name,
      subject_id: self.id,
      valid_guest_actions: "accusations",
    ).first
    
    if existing_permission_share.nil?
      share = Share.build_share(owner_identity: self.identity)
      share.save!
      
      PermissionShare.create!(
        identity_id: self.identity_id,
        share: share,
        subject_class: self.class.name,
        subject_id: self.id,
        valid_guest_actions: "accusations",
      )
      
      token = share.token
    else
      token = existing_permission_share.share.token
    end
    reputation_report_accusations_url(self, token: token)
  end
end
