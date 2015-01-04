require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Location
  end
  
  def test_attributes
    { name: "test" }
  end
end
