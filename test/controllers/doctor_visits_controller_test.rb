require 'test_helper'

class DoctorVisitsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { visit_date: DateTime.now }
  end
end
