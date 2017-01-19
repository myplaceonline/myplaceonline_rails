class DentalInsuranceFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :dental_insurance

  child_property(name: :identity_file, required: true)
end
