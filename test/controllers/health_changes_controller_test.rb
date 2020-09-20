require 'test_helper'

class HealthChangesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { change_name: "test" }
  end
end
