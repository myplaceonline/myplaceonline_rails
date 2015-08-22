require 'test_helper'

class HobbiesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Hobby
  end
  
  def test_attributes
    { hobby_name: "test" }
  end
end
