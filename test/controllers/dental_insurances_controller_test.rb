require 'test_helper'

class DentalInsurancesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    DentalInsurance
  end
  
  def test_attributes
    { insurance_name: "test" }
  end
end
