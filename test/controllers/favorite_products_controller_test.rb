require 'test_helper'

class FavoriteProductsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    FavoriteProduct
  end
  
  def test_attributes
    { product_name: "test" }
  end
end
