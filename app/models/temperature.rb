class Temperature < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :measured, presence: true
  validates :temperature_type, presence: true
  validates :measured_temperature, presence: true
  
  def display
    result = measured_temperature.to_s
    result += " " + Myp.get_select_name(temperature_type, Myp::TEMPERATURES)
    result += " (" + Myp.display_date(measured, User.current_user) + ")"
    result
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.temperature_type = 0
    result.measured = User.current_user.time_now
    result
  end
end
