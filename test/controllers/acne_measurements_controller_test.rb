require 'test_helper'

class AcneMeasurementsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { measurement_datetime: DateTime.now }
  end
end
