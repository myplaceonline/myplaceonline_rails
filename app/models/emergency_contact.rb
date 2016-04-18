class EmergencyContact < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :email, presence: true

  belongs_to :email, :dependent => :destroy
  accepts_nested_attributes_for :email, reject_if: :all_blank

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
  
  def send_contact(is_new, obj, description)
    cat = Myp.instance_to_category(obj).human_title_singular
    e = email.dup
    email.email_contacts.each do |email_contact|
      e.email_contacts << email_contact.dup
    end
    email.email_groups.each do |email_group|
      e.email_groups << email_group.dup
    end
    e.subject = I18n.t(
      is_new ? "myplaceonline.emergency_contacts.subject_new" : "myplaceonline.emergency_contacts.subject_edit",
      {
        contact: identity.display_short,
        category: cat
      }
    )
    e.body = description
    e.save!
    e.process
  end
end
