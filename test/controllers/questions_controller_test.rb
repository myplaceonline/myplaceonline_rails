require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Question
  end
  
  def test_attributes
    { name: "test" }
  end
end
