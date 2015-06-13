require 'test_helper'

class PromotionsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Promotion
  end
  
  def test_attributes
    { promotion_name: "test" }
  end
end
