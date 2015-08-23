require 'test_helper'

class SleepMeasurementsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { sleep_start_time: Time.now }
  end
end
