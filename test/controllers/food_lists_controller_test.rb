require 'test_helper'

class FoodListsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { food_list_name: "test" }
  end
end
