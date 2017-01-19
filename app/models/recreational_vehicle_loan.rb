class RecreationalVehicleLoan < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :recreational_vehicle

  child_property(name: :loan)
end
