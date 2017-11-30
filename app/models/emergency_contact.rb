class EmergencyContact < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  child_property(name: :email, required: true)

  def display
    email.all_targets.values.to_a.map{|x| x.display }.join(", ")
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.email = Email.new
    result.email.set_subject("N/A")
    result.email.set_body_if_blank("N/A")
    result.email.draft = true
    result.email.email_category = I18n.t("myplaceonline.emails.category_emergency")
    result
  end
  
  def send_contact(is_new, obj, body_short_markdown, body_long_markdown, subject_append = nil, suppress_sms_prefix: false)
    
    if self.email.email_groups.length > 0
      raise "Not implemented"
    end
    
    category = Myp.instance_to_category(obj)
    
    Rails.logger.debug{"EmergencyContact.send_contact category: #{category}"}

    verb = "myplaceonline.emergency_contacts.verb_created"
    if obj.respond_to?("emergency_contact_create_verb")
      verb = obj.emergency_contact_create_verb
    end
    
    subject = I18n.t(
      is_new ? "myplaceonline.emergency_contacts.subject_new" : "myplaceonline.emergency_contacts.subject_edit",
      {
        contact: identity.display_short,
        subject: "#{category.human_title_singular}#{subject_append}",
        verb: I18n.t(verb)
      }
    )
    
    body_long_markdown += "\n\n" + I18n.t("myplaceonline.emergency_contacts.why_contacted")
    
    self.email.email_contacts.each do |email_contact|
      email_contact.contact.send_message_with_conversation(body_short_markdown, body_long_markdown, subject, category.human_title, suppress_sms_prefix: suppress_sms_prefix)
    end

  end
end
