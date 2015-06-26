require 'test_helper'

class LifeInsurancesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    LifeInsurance
  end
  
  def test_attributes
    { insurance_name: "test", insurance_amount: 1 }
  end
end
