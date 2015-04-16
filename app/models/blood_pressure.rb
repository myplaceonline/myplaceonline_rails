class BloodPressure < ActiveRecord::Base
  belongs_to :identity
  
  # systolic_pressure:integer diastolic_pressure:integer measurement_date:date measurement_source:string

  validates :systolic_pressure, presence: true
  validates :diastolic_pressure, presence: true
  validates :measurement_date, presence: true
  
  def display
    systolic_pressure.to_s + "/" + diastolic_pressure.to_s + " (" + Myp.display_date(measurement_date, User.current_user) + ")"
  end

  before_create :do_before_save
  before_update :do_before_save
  
  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
