class Email < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

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
    
    bcc = nil
    if copy_self
      bcc = identity.user.email
    end
    to_hash = {}
    email_contacts.each do |email_contact|
      email_contact.contact.contact_identity.emails.each do |identity_email|
        to_hash[identity_email] = true
      end
    end
    email_groups.each do |email_group|
      process_group(to_hash, email_group.group)
    end
    Myp.send_email(to_hash.keys, subject, content.html_safe, nil, bcc, content_plain)
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
end
