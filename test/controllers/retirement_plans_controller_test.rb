require 'test_helper'

class RetirementPlansControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { retirement_plan_name: "test" }
  end
end
