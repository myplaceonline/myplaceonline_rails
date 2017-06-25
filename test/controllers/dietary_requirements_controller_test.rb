require 'test_helper'

class DietaryRequirementsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { dietary_requirement_name: "test" }
  end
end
