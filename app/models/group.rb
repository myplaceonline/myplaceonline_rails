class Group < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :group_name, presence: true
  
  child_properties(name: :group_contacts)

  child_properties(name: :group_references, foreign_key: "parent_group_id")
  
  child_files

  def display
    group_name
  end
  
  def all_contacts
    group_contacts.map{|gc| gc.contact} + group_references.map{|gf| gf.group.all_contacts}.flatten
  end

  def self.skip_check_attributes
    ["mailing_list"]
  end
  
  def has_email?(check_email)
    group_contacts.each do |group_contact|
      if group_contact.contact.contact_identity.identity_emails.any?{|identity_email| identity_email.email == check_email }
        return true
      end
    end
    return false
  end
end
