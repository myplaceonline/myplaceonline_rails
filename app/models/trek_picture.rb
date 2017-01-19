class TrekPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :trek

  child_property(name: :identity_file, required: true)
end
