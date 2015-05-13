require 'test_helper'

class MedicineUsagesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    MedicineUsage
  end
  
  def test_attributes
    { usage_time: DateTime.now }
  end
end
