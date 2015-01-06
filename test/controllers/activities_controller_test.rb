require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Activity
  end
  
  def test_attributes
    { name: "test" }
  end
end
