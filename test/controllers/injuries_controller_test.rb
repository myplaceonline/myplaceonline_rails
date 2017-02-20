require 'test_helper'

class InjuriesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { injury_name: "test" }
  end
end
