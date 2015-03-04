require 'test_helper'

class CalculationsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Calculation
  end
  
  def test_attributes
    { name: "test" }
  end
end
