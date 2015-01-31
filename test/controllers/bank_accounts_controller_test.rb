require 'test_helper'

class BankAccountsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    BankAccount
  end
  
  def test_attributes
    { name: "Test", account_number: 1, routing_number: 1 }
  end
end
