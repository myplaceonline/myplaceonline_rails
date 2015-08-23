require 'test_helper'

class CreditCardsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { name: "Test", number: 1, expires: "2015-01-01", security_code: 1 }
  end
end
