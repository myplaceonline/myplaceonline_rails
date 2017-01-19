class IdentityPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :parent_identity, class_name: Identity

  child_property(name: :identity_file, required: true)
end
