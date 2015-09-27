class VehicleService < MyplaceonlineIdentityRecord
  belongs_to :vehicle
  validates :short_description, presence: true

  after_save { |record| DueItem.due_vehicles(User.current_user) }
  after_destroy { |record| DueItem.due_vehicles(User.current_user) }
end
