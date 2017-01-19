class Myreference < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  REFERENCE_TYPES = [
    ["myplaceonline.myreferences.type_personal", 0],
    ["myplaceonline.myreferences.type_professional", 1],
    ["myplaceonline.myreferences.type_educational", 2]
  ]

  def display
    contact.display
  end
  
  child_property(name: :contact, required: true)
  
  def self.search_join
    :contact
  end
  
  def self.search_join_where
    :contact_identity_id
  end

  def self.skip_check_attributes
    ["can_contact"]
  end
end
