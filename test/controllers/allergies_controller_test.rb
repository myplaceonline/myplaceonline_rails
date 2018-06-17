require 'test_helper'

class AllergiesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { allergy_description: "test" }
  end
end
