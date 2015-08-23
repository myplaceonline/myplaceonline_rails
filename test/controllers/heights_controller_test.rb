require 'test_helper'

class HeightsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { height_amount: 1, amount_type: 0, measurement_date: Time.now }
  end
end
