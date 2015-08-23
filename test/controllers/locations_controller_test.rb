require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { name: "test" }
  end
end
