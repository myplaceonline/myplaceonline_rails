class IdentityEmail < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :parent_identity, class_name: Identity
  
  def final_search_result
    parent_identity.contact
  end

  def self.skip_check_attributes
    ["secondary"]
  end
end
