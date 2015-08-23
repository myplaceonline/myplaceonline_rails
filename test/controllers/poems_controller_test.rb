require 'test_helper'

class PoemsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Poem
  end
  
  def test_attributes
    { poem_name: "test" }
  end
end
