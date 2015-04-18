require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Recipe
  end
  
  def test_attributes
    { name: "test" }
  end
end
