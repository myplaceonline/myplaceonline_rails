require 'test_helper'

class RecreationalVehiclesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    RecreationalVehicle
  end
  
  def test_attributes
    { rv_name: "test" }
  end
end
