require 'test_helper'

class PromotionsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { promotion_name: "test" }
  end
end
