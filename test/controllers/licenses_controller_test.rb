require 'test_helper'

class LicensesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { license_name: "test" }
  end
end
