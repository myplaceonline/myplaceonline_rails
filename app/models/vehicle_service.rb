class VehicleService < MyplaceonlineIdentityRecord
  belongs_to :vehicle
  validates :short_description, presence: true
end
