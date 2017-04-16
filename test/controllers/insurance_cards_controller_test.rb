require 'test_helper'

class InsuranceCardsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { insurance_card_name: "test" }
  end
end
