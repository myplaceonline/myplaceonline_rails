require 'test_helper'

class HappyThingsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { happy_thing_name: "test" }
  end
end
