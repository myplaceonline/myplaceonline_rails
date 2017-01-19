class VehicleInsurance < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :vehicle

  validates :insurance_name, presence: true

  child_property(name: :company)

  child_property(name: :periodic_payment)
end
