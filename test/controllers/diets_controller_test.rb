require 'test_helper'

class DietsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { diet_name: "Test" }
  end
end
