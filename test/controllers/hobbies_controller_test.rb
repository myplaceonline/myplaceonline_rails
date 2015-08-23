require 'test_helper'

class HobbiesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { hobby_name: "test" }
  end
end
