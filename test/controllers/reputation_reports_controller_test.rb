require 'test_helper'

class ReputationReportsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { short_description: "test", story: "test" }
  end
end
