require 'test_helper'

class BloodTestsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { fast_started: Time.now }
  end
end
