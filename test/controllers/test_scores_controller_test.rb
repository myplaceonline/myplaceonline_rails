require 'test_helper'

class TestScoresControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { test_score_name: "test" }
  end
end
