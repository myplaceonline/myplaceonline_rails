class IdentityEmail < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :parent_identity, class_name: Identity
end
