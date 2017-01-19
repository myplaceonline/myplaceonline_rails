class DonationFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :donation

  child_property(name: :identity_file, required: true)
end
