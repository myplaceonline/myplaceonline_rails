class IdentityFileShare < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :identity_file
  belongs_to :share
end
