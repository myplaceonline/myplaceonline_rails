require 'test_helper'

class TemperaturesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { measured_temperature: 1, temperature_type: 0, measured: Time.now }
  end
end
