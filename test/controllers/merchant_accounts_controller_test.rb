require 'test_helper'

class MerchantAccountsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { merchant_account_name: "test" }
  end
end
