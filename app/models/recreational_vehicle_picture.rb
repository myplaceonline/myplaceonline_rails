class RecreationalVehiclePicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :recreational_vehicle

  child_property(name: :identity_file, required: true)
end
