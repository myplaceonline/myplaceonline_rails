require 'test_helper'

class RestaurantDishesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { dish_name: "test" }
  end
end
