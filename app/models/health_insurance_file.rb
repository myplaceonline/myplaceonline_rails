class HealthInsuranceFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :health_insurance

  child_property(name: :identity_file, required: true)
end
