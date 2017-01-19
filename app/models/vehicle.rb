class Vehicle < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  ENGINE_TYPES = [["myplaceonline.vehicles.gas", 0], ["myplaceonline.vehicles.diesel", 1]]
  DISPLACEMENT_TYPES = [["myplaceonline.vehicles.litres", 0]]
  DOOR_TYPES = [["myplaceonline.vehicles.doors_standard", 0], ["myplaceonline.vehicles.doors_extended", 1], ["myplaceonline.vehicles.doors_crew", 2]]
  DRIVE_TYPES = [["myplaceonline.vehicles.front_wheel_drive", 0], ["myplaceonline.vehicles.rear_wheel_drive", 1]]
  WHEEL_TYPES = [["myplaceonline.vehicles.single_rear_wheel", 0], ["myplaceonline.vehicles.dual_rear_wheels", 1]]
  
  validates :name, presence: true

  child_properties(name: :vehicle_loans)

  child_properties(name: :vehicle_services)
  
  child_properties(name: :vehicle_insurances)
  
  child_property(name: :recreational_vehicle)

  child_properties(name: :vehicle_pictures)

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(vehicle_pictures, [I18n.t("myplaceonline.category.vehicles"), name])
  end
  
  child_properties(name: :vehicle_warranties)

  child_properties(name: :vehicle_registrations, sort: "registration_date DESC")

  def display
    Myp.appendstrwrap(name, license_plate)
  end
end
