require 'test_helper'

class DietaryRequirementsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { dietary_requirement_name: "test", dietary_requirement_amount: 1 }
  end
end
