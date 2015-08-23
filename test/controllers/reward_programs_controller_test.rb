require 'test_helper'

class RewardProgramsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { reward_program_name: "test" }
  end
end
