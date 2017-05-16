class IdentityPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :identity_file, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end
  
  child_file(parent: :parent_identity, class_name: "Identity")
end
