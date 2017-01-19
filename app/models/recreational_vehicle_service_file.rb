class RecreationalVehicleServiceFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :recreational_vehicle_service

  child_property(name: :identity_file, required: true)
end
