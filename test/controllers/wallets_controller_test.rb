require 'test_helper'

class WalletsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { wallet_name: "test", balance: 0 }
  end
end
