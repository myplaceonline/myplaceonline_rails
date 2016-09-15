require 'test_helper'

class ExerciseRegimensControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { exercise_regimen_name: "test" }
  end
end
