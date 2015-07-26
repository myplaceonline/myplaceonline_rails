class RecreationalVehicleMeasurement < ActiveRecord::Base
  belongs_to :recreational_vehicle
  belongs_to :owner, class_name: Identity

  validates :measurement_name, presence: true
  
  def display
    measurement_name
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
