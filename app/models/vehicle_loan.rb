class VehicleLoan < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :vehicle

  child_property(name: :loan)
end
