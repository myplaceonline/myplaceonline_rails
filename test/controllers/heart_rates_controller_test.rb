require 'test_helper'

class HeartRatesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { beats: 70, measurement_date: Time.now }
  end
end
