require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { name: "test" }
  end
end
