require 'test_helper'

class TherapistsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Therapist
  end
  
  def test_attributes
    { name: "test" }
  end
end
