require 'test_helper'

class QuizzesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { quiz_name: "test" }
  end
end
