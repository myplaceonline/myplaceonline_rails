class VehiclePicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :vehicle

  child_property(name: :identity_file, required: true)
end
