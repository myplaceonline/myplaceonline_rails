class Group < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :group_name, presence: true
  
  child_properties(name: :group_contacts)

  child_properties(name: :group_references, foreign_key: "parent_group_id")

  def display
    group_name
  end
  
  def all_contacts
    group_contacts.map{|gc| gc.contact} + group_references.map{|gf| gf.group.all_contacts}.flatten
  end
end
