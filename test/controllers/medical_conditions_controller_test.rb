require 'test_helper'

class MedicalConditionsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { medical_condition_name: "test" }
  end
end
