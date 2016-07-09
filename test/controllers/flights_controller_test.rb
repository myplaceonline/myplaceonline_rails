require 'test_helper'

class FlightsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { flight_name: "test" }
  end
end
