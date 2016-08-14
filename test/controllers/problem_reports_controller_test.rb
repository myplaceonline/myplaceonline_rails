require 'test_helper'

class ProblemReportsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { report_name: "test" }
  end
end
