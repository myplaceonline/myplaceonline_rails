require 'test_helper'

class SurgeriesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { surgery_name: "test" }
  end
end
