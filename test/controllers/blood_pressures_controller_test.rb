require 'test_helper'

class BloodPressuresControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    BloodPressure
  end
  
  def test_attributes
    { systolic_pressure: 110, diastolic_pressure: 70, measurement_date: Time.now }
  end
end
