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
  
  def send_contact(is_new, obj, description, subject_append = nil)
    cat = Myp.instance_to_category(obj).human_title_singular
    e = email.dup
    email.email_contacts.each do |email_contact|
      e.email_contacts << email_contact.dup
    end
    email.email_groups.each do |email_group|
      e.email_groups << email_group.dup
    end
    e_verb = "myplaceonline.emergency_contacts.verb_created"
    if obj.respond_to?("emergency_contact_create_verb")
      e_verb = obj.emergency_contact_create_verb
    end
    e.subject = I18n.t(
      is_new ? "myplaceonline.emergency_contacts.subject_new" : "myplaceonline.emergency_contacts.subject_edit",
      {
        contact: identity.display_short,
        subject: cat + subject_append,
        verb: I18n.t(e_verb)
      }
    )
    e.body = description
    e.body += "\n\n" + I18n.t("myplaceonline.emergency_contacts.why_contacted")
    e.save!
    e.process
  end
end
