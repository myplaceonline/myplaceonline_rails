class Email < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  validates :subject, presence: true
  validates :body, presence: true
  validates :email_category, presence: true

  has_many :email_contacts, :dependent => :destroy
  accepts_nested_attributes_for :email_contacts, allow_destroy: true, reject_if: :all_blank

  has_many :email_groups, :dependent => :destroy
  accepts_nested_attributes_for :email_groups, allow_destroy: true, reject_if: :all_blank

  def display
    subject
  end

  validate do
    if email_contacts.length == 0 && email_groups.length == 0
      errors.add(:email_contacts, I18n.t("myplaceonline.permissions.requires_contacts"))
    end
  end

  def send_email
    content_plain = body
    content = "<p>" + Myp.markdown_to_html(body) + "</p>"
    
    targets = {}

    email_contacts.each do |email_contact|
      email_contact.contact.contact_identity.emails.each do |identity_email|
        targets[identity_email] = true
      end
    end

    email_groups.each do |email_group|
      process_group(targets, email_group.group)
    end
    
    target_emails = targets.keys
    target_emails.delete_if{
      |target_email|

      !EmailUnsubscription.where(
        "email = ? and (category is null or category = ?)",
        target_email,
        email_category
      ).first.nil?
    }
    
    user_display = identity.display
    
    target_emails.each do |target|
      to_hash = {}
      cc_hash = {}
      bcc_hash = {}
      
      if use_bcc
        bcc_hash[target] = true
      else
        cc_hash[target] = true
      end

      if copy_self
        bcc_hash[identity.user.email] = true
      end
      
      et = EmailToken.new
      et.token = SecureRandom.hex(10)
      et.email = target
      et.save!
      
      unsubscribe_all_link = unsubscribe_url(email: target, token: et.token)
      unsubscribe_category_link = unsubscribe_url(email: target, category: email_category, token: et.token)

      final_content = content + "\n\n"
      final_content += "<p>#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.unsubscribe.link_unsubscribe_category", user: user_display, category: email_category), unsubscribe_category_link)}</p>\n"
      final_content += "<p>#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.unsubscribe.link_unsubscribe_all", user: user_display), unsubscribe_all_link)}</p>"
      
      final_content_plain = content_plain + "\n\n"
      final_content_plain += "#{I18n.t("myplaceonline.unsubscribe.link_unsubscribe_category", user: user_display, category: email_category)}: #{unsubscribe_category_link}\n"
      final_content_plain += "#{I18n.t("myplaceonline.unsubscribe.link_unsubscribe_all", user: user_display)}: #{unsubscribe_all_link}"

      Myp.send_email(
        to_hash.keys,
        subject,
        final_content.html_safe,
        cc_hash.keys,
        bcc_hash.keys,
        final_content_plain
      )
    end
  end
  
  def process_group(to_hash, group)
    group.group_contacts.each do |group_contact|
      group_contact.contact.contact_identity.emails.each do |identity_email|
        to_hash[identity_email] = true
      end
    end
    group.group_references.each do |group_reference|
      process_group(to_hash, group_reference.group)
    end
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.use_bcc = true
    result.copy_self = true
    result
  end

  protected
  def default_url_options
    Rails.configuration.default_url_options
  end
end
