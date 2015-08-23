require 'test_helper'

class CreditScoresControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { score_date: "2015-01-01", score: 1 }
  end
end
