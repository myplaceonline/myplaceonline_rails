class VehicleService < MyplaceonlineActiveRecord
  belongs_to :vehicle
  validates :short_description, presence: true
end
