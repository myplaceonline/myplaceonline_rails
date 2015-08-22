class BloodPressure < MyplaceonlineActiveRecord
  validates :systolic_pressure, presence: true
  validates :diastolic_pressure, presence: true
  validates :measurement_date, presence: true
  
  def display
    systolic_pressure.to_s + "/" + diastolic_pressure.to_s + " (" + Myp.display_date(measurement_date, User.current_user) + ")"
  end
end
