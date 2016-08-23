class IdentityEmail < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :parent_identity, class_name: Identity
  
  def final_search_result
    parent_identity.contact
  end
end
