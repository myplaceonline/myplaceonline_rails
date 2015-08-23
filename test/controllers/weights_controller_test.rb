require 'test_helper'

class WeightsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { amount: 1, amount_type: 0, measure_date: Time.now }
  end
end
