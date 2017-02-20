require 'test_helper'

class HospitalVisitsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { hospital_visit_purpose: "test" }
  end
end
