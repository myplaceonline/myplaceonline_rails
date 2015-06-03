require 'test_helper'

class PeriodicPaymentsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    PeriodicPayment
  end
  
  def test_attributes
    { periodic_payment_name: "test" }
  end
end
