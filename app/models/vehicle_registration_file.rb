class VehicleRegistrationFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :vehicle_registration

  child_property(name: :identity_file, required: true)
end
