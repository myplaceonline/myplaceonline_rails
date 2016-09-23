require 'test_helper'

class BloodTestsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { test_time: Time.now }
  end
end
