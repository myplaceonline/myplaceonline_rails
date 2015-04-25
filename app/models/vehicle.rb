class Vehicle < ActiveRecord::Base
  
  ENGINE_TYPES = [["myplaceonline.vehicles.gas", 0], ["myplaceonline.vehicles.diesel", 1]]
  DISPLACEMENT_TYPES = [["myplaceonline.vehicles.litres", 0]]
  DOOR_TYPES = [["myplaceonline.vehicles.doors_standard", 0], ["myplaceonline.vehicles.doors_extended", 1], ["myplaceonline.vehicles.doors_crew", 2]]
  DRIVE_TYPES = [["myplaceonline.vehicles.front_wheel_drive", 0], ["myplaceonline.vehicles.rear_wheel_drive", 1]]
  WHEEL_TYPES = [["myplaceonline.vehicles.single_rear_wheel", 0], ["myplaceonline.vehicles.dual_rear_wheels", 1]]
  
  belongs_to :identity
  validates :name, presence: true

  has_many :vehicle_loans, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_loans, allow_destroy: true, reject_if: :all_blank

  has_many :vehicle_services, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_services, allow_destroy: true, reject_if: :all_blank
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
