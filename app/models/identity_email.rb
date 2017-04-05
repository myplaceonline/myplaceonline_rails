class IdentityEmail < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  def self.properties
    [
      { name: :email, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :secondary, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
    ]
  end
  
  belongs_to :parent_identity, class_name: Identity
  
  def final_search_result
    parent_identity.contact
  end

  def self.skip_check_attributes
    ["secondary"]
  end
end
