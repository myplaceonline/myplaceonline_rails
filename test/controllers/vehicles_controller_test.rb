require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Vehicle
  end
  
  def test_attributes
    { name: "test" }
  end
end
