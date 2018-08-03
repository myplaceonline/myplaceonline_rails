require 'test_helper'

class PresentsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { present_name: "test" }
  end
end
