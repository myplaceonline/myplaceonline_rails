class RecreationalVehicleServiceFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :recreational_vehicle_service)
end
