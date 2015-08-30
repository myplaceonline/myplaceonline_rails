require 'test_helper'

class DentistVisitsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { visit_date: DateTime.now }
  end
end
