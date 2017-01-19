class LocationPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :location

  child_property(name: :identity_file, required: true)
end
