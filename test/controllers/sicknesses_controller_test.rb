require 'test_helper'

class SicknessesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { sickness_start: DateTime.now }
  end
end
