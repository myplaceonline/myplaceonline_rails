class Message < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :body, presence: true
  validates :long_body, presence: true
  validates :message_category, presence: true
  validates :send_preferences, presence: true

  child_properties(name: :message_contacts)

  child_properties(name: :message_groups)

  SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_EMAIL = 0
  SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_TEXT = 1
  SEND_PREFERENCE_EMAIL_AND_TEXT = 2
  SEND_PREFERENCE_EMAIL = 3
  SEND_PREFERENCE_TEXT = 4
  
  SEND_PREFERENCE_DEFAULT = SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_EMAIL

  SEND_PREFERENCES = [
    ["myplaceonline.messages.send_preferences.email_or_text_prefer_email", SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_EMAIL],
    ["myplaceonline.messages.send_preferences.email_or_text_prefer_text", SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_TEXT],
    ["myplaceonline.messages.send_preferences.email_and_text", SEND_PREFERENCE_EMAIL_AND_TEXT],
    ["myplaceonline.messages.send_preferences.email", SEND_PREFERENCE_EMAIL],
    ["myplaceonline.messages.send_preferences.text", SEND_PREFERENCE_TEXT],
  ]
  
  def display
    Myp.ellipses_if_needed(body, 32)
  end

  validate do
    if !draft && message_contacts.length == 0 && message_groups.length == 0
      errors.add(:message_contacts, I18n.t("myplaceonline.permissions.requires_contacts"))
    elsif !draft && self.send_emails? && self.subject.blank?
      errors.add(:subject, I18n.t("myplaceonline.messages.subject_required_for_email"))
    end
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.send_preferences = SEND_PREFERENCE_DEFAULT
    result
  end
  
  def process
    if !self.draft
      case self.send_preferences
      when SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_EMAIL
        Rails.logger.debug{"Message.process e_or_t_email"}
        contacts_found = self.do_send_emails
        Rails.logger.debug{"Message.process emails found: #{contacts_found.length}"}
        contacts_found = self.do_send_texts(skip_contacts: contacts_found)
        Rails.logger.debug{"Message.process texts found: #{contacts_found.length}"}
      when SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_TEXT
        Rails.logger.debug{"Message.process e_or_t_t"}
        contacts_found = self.do_send_texts
        Rails.logger.debug{"Message.process texts found: #{contacts_found.length}"}
        contacts_found = self.do_send_emails(skip_contacts: contacts_found)
        Rails.logger.debug{"Message.process emails found: #{contacts_found.length}"}
      when SEND_PREFERENCE_EMAIL_AND_TEXT
        Rails.logger.debug{"Message.process e_and_t"}
        contacts_found = self.do_send_emails
        Rails.logger.debug{"Message.process emails found: #{contacts_found.length}"}
        contacts_found = self.do_send_texts
        Rails.logger.debug{"Message.process texts found: #{contacts_found.length}"}
      when SEND_PREFERENCE_EMAIL
        Rails.logger.debug{"Message.process e"}
        contacts_found = self.do_send_emails
        Rails.logger.debug{"Message.process emails found: #{contacts_found.length}"}
      when SEND_PREFERENCE_TEXT
        Rails.logger.debug{"Message.process t"}
        contacts_found = self.do_send_texts
        Rails.logger.debug{"Message.process texts found: #{contacts_found.length}"}
      else
        raise "TODO"
      end
    end
  end
  
  def should_send_email?(contact:, skip_contacts:)
    skip_contacts.index{|x| x.id == contact.id}.nil? && contact.send_email?
  end
  
  def do_send_emails(skip_contacts: [])
    
    contacts_found = []
    
    email = Email.new(
      subject: self.subject,
      body: self.long_body,
      copy_self: self.copy_self,
      email_category: self.message_category,
      identity_id: self.identity_id,
      draft: self.draft,
      personalize: self.personalize,
      suppress_signature: self.suppress_signature,
      reply_to: self.reply_to,
      suppress_context_info: self.suppress_context_info,
    )
    self.message_contacts.each do |x|
      if x.contact.has_email? && should_send_email?(contact: x.contact, skip_contacts: skip_contacts)
        email.email_contacts << EmailContact.new(contact: x.contact)
        contacts_found << x.contact
      end
    end
    self.message_groups.each do |x|
      x.group.group_contacts.each do |y|
        if y.contact.has_email? && should_send_email?(contact: y.contact, skip_contacts: skip_contacts)
          email.email_contacts << EmailContact.new(contact: y.contact)
          contacts_found << y.contact
        end
      end
      #email.email_groups << EmailGroup.new(group: x.group)
    end
    
    if contacts_found.length > 0
      email.save!
      email.process
    end
    
    contacts_found
  end
  
  def should_send_text?(contact:, skip_contacts:)
    skip_contacts.index{|x| x.id == contact.id}.nil? && contact.send_text?
  end
  
  def do_send_texts(skip_contacts: [])

    contacts_found = []

    sms = TextMessage.new(
      body: self.body,
      copy_self: self.copy_self,
      message_category: self.message_category,
      identity_id: self.identity_id,
      draft: self.draft,
      personalize: self.personalize,
      long_body: self.long_body,
      suppress_prefix: suppress_prefix,
    )
    self.message_contacts.each do |x|
      if x.contact.has_mobile? && should_send_text?(contact: x.contact, skip_contacts: skip_contacts)
        sms.text_message_contacts << TextMessageContact.new(contact: x.contact)
        contacts_found << x.contact
      end
    end
    self.message_groups.each do |x|
      x.group.group_contacts.each do |y|
        if y.contact.has_mobile? && should_send_text?(contact: y.contact, skip_contacts: skip_contacts)
          sms.text_message_contacts << TextMessageContact.new(contact: y.contact)
          contacts_found << y.contact
        end
      end
      #sms.text_message_groups << TextMessageGroup.new(group: x.group)
    end
    
    if contacts_found.length > 0
      sms.save!
      sms.process
    end
    
    contacts_found
  end

  def self.skip_check_attributes
    ["draft", "copy_self", "suppress_signature"]
  end
  
  def send_immediately
    false
  end
  
  def send_emails?
    self.send_preferences == SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_EMAIL ||
        self.send_preferences == SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_TEXT ||
        self.send_preferences == SEND_PREFERENCE_EMAIL_AND_TEXT ||
        self.send_preferences == SEND_PREFERENCE_EMAIL
  end
  
  def send_texts?
    self.send_preferences == SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_EMAIL ||
        self.send_preferences == SEND_PREFERENCE_EMAIL_OR_TEXT_PREFER_TEXT ||
        self.send_preferences == SEND_PREFERENCE_EMAIL_AND_TEXT ||
        self.send_preferences == SEND_PREFERENCE_TEXT
  end
end
