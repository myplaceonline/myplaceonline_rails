class Message < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :body, presence: true
  validates :message_category, presence: true

  child_properties(name: :message_contacts)

  child_properties(name: :message_groups)

  def display
    Myp.ellipses_if_needed(body, 32)
  end

  validate do
    if !draft && message_contacts.length == 0 && message_groups.length == 0
      errors.add(:message_contacts, I18n.t("myplaceonline.permissions.requires_contacts"))
    elsif !draft && self.send_emails && self.subject.blank?
      errors.add(:subject, I18n.t("myplaceonline.messages.subject_required_for_email"))
    end
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.send_emails = true
    result.send_texts = true
    result
  end
  
  def process
    if self.send_emails
      email = Email.new(
        subject: self.subject,
        body: self.body,
        copy_self: self.copy_self,
        email_category: self.message_category,
        identity_id: self.identity_id,
        draft: self.draft,
        personalize: self.personalize
      )
      self.message_contacts.each do |x|
        email.email_contacts << EmailContact.new(contact: x.contact)
      end
      self.message_groups.each do |x|
        email.email_groups << EmailGroup.new(group: x.group)
      end
      email.save!
      email.process
    end
    if self.send_texts
      sms = TextMessage.new(
        body: self.body,
        copy_self: self.copy_self,
        message_category: self.message_category,
        identity_id: self.identity_id,
        draft: self.draft,
        personalize: self.personalize
      )
      self.message_contacts.each do |x|
        sms.text_message_contacts << TextMessageContact.new(contact: x.contact)
      end
      self.message_groups.each do |x|
        sms.text_message_groups << TextMessageGroup.new(group: x.group)
      end
      sms.save!
      sms.process
    end
  end

  def self.skip_check_attributes
    ["send_emails", "send_texts", "draft", "copy_self"]
  end
end
