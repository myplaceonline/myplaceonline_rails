require 'test_helper'

class DriverLicensesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { driver_license_identifier: "test" }
  end
end
