class Temperature < ActiveRecord::Base
  belongs_to :identity
  validates :measured, presence: true
  validates :temperature_type, presence: true
  validates :measured_temperature, presence: true
  
  def display
    result = measured_temperature.to_s
    result += " " + Myp.get_select_name(temperature_type, Myp::TEMPERATURES)
    result += " (" + Myp.display_date(measured, User.current_user) + ")"
    result
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
