require 'test_helper'

class BetsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { bet_name: "test", bet_amount: 1 }
  end
end
