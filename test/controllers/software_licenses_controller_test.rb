require 'test_helper'

class SoftwareLicensesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { license_name: "test" }
  end
end
