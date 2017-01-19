class TextMessage < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :body, presence: true
  validates :message_category, presence: true

  child_properties(name: :text_message_contacts)

  child_properties(name: :text_message_groups)

  def display
    body
  end

  validate do
    if !draft && text_message_contacts.length == 0 && text_message_groups.length == 0
      errors.add(:text_message_contacts, I18n.t("myplaceonline.permissions.requires_contacts"))
    end
  end
  
  def all_targets
    targets = {}

    text_message_contacts.each do |text_message_contact|
      text_message_contact.contact.contact_identity.identity_phones.each do |identity_phone|
        if identity_phone.accepts_sms?
          targets[identity_phone.number] = text_message_contact.contact
        end
      end
    end

    text_message_groups.each do |text_message_group|
      process_group(targets, text_message_group.group)
    end
    
    targets
  end
  
  def send_sms()
    targets = all_targets

    targets.each do |target, contact|
      process_single_target(target, nil, contact)
    end
    if copy_self
      User.current_user.primary_identity.identity_phones.each do |identity_phone|
        if identity_phone.accepts_sms?
          process_single_target(identity_phone.number)
        end
      end
    end
  end
  
  def process_single_target(target, content = nil, contact = nil)
    Rails.logger.debug{"SMS process_single_target target: #{target}, content: #{content}"}

    if content.nil?
      content = "#{identity.display_short} #{I18n.t("myplaceonline.emails.from_prefix_context")} #{I18n.t("myplaceonline.siteTitle")} #{I18n.t("myplaceonline.emails.subject_shared")}: "
      content += body
    end
    
    if TextMessageUnsubscription.where(
        "phone_number = ? and (category is null or category = ?) and (identity_id is null or identity_id = ?)",
        target,
        message_category,
        identity.id
      ).first.nil?
      
      Rails.logger.info{"Sending SMS to #{target}"}

      Myp.send_sms(to: target, body: body)

      if !contact.nil?
        async = ExecutionContext.count == 0
        begin
          if async
            ExecutionContext.push
            User.current_user = self.identity.user
          end
          # If we sent an email, add a conversation
          Conversation.new(
            contact: contact,
            identity: identity,
            conversation: "[#{body}](/text_messages/#{id})",
            conversation_date: User.current_user.date_now
          ).save!
        ensure
          if async
            ExecutionContext.pop
          end
        end
      end
      
      sleep(1.0)
    end
  end
  
  def process_group(to_hash, group)
    group.group_contacts.each do |group_contact|
      group_contact.contact.contact_identity.identity_phones.each do |identity_phone|
        if identity_phone.accepts_sms?
          to_hash[identity_phone.number] = group_contact.contact
        end
      end
    end
    group.group_references.each do |group_reference|
      process_group(to_hash, group_reference.group)
    end
  end

  def send_immediately
    text_message_groups.count == 0 && text_message_contacts.count < 5
  end
  
  def process
    if send_immediately
      AsyncTextMessageJob.perform_now(self)
    else
      AsyncTextMessageJob.perform_later(self)
    end
  end

  def self.skip_check_attributes
    ["draft", "copy_self"]
  end
end
