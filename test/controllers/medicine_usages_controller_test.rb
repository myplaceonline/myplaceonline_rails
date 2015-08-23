require 'test_helper'

class MedicineUsagesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { usage_time: DateTime.now }
  end
end
