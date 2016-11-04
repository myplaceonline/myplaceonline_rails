require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { item_name: "test" }
  end
end
