require 'test_helper'

class SunExposuresControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { exposure_start: DateTime.now }
  end
end
