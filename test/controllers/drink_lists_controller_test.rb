require 'test_helper'

class DrinkListsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { drink_list_name: "test" }
  end
end
