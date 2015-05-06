require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Exercise
  end
  
  def test_attributes
    { exercise_start: DateTime.now }
  end
end
