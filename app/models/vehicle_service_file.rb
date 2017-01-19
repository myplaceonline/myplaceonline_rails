class VehicleServiceFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :vehicle_service

  child_property(name: :identity_file, required: true)
end
