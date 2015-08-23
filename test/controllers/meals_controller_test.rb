require 'test_helper'

class MealsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { meal_time: DateTime.now }
  end
end
