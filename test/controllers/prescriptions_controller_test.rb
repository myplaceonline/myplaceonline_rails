require 'test_helper'

class PrescriptionsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { prescription_name: "test" }
  end
end
