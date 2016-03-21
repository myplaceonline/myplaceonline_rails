require 'test_helper'

class TimingsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { timing_name: "test" }
  end
end
