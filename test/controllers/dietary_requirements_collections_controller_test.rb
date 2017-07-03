require 'test_helper'

class DietaryRequirementsCollectionsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { dietary_requirements_collection_name: "test", dietary_requirement_amount: 1 }
  end
end
