require 'test_helper'

class DesiredProductsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { product_name: "test" }
  end
end
