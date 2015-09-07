require 'test_helper'

class ShoppingListsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { shopping_list_name: "test" }
  end
end
