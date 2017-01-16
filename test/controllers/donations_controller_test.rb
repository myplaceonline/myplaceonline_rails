require 'test_helper'

class DonationsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { donation_name: "test" }
  end
end
