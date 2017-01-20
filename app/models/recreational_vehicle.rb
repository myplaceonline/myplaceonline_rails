class RecreationalVehicle < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :rv_name, presence: true
  
  def display
    rv_name
  end

  child_property(name: :location_purchased, model: Location)

  child_properties(name: :recreational_vehicle_loans)

  child_pictures

  child_properties(name: :recreational_vehicle_insurances)
  
  child_properties(name: :recreational_vehicle_measurements)

  child_properties(name: :recreational_vehicle_services)

  def self.skip_check_attributes
    ["dimensions_type", "weight_type", "liquid_capacity_type", "volume_type"]
  end
end
