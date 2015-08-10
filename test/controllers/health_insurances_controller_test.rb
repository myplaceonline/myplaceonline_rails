require 'test_helper'

class HealthInsurancesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    HealthInsurance
  end
  
  def test_attributes
    { insurance_name: "test" }
  end
end
