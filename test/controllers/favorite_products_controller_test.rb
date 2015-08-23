require 'test_helper'

class FavoriteProductsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { product_name: "test" }
  end
end
