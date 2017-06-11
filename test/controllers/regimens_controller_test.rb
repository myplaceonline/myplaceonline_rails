require 'test_helper'

class RegimensControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { regimen_name: "test" }
  end
end
