require 'test_helper'

class LifeGoalsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    LifeGoal
  end
  
  def test_attributes
    { life_goal_name: "test" }
  end
end
