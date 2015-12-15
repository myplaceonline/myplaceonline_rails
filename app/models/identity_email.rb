class IdentityEmail < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :identity, class_name: Identity
end
