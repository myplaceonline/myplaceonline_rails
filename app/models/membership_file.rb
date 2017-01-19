class MembershipFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :membership

  child_property(name: :identity_file, required: true)
end
