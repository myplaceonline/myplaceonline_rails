require 'test_helper'

class PsychologicalEvaluationsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { psychological_evaluation_name: "test" }
  end
end
