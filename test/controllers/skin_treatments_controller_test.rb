require 'test_helper'

class SkinTreatmentsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { treatment_time: DateTime.now }
  end
end
