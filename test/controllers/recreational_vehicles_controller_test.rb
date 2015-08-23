require 'test_helper'

class RecreationalVehiclesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { rv_name: "test" }
  end
end
