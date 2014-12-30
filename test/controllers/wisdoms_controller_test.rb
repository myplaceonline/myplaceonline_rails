require 'test_helper'

class WisdomsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Wisdom
  end
  
  def test_attributes
    { name: "test" }
  end
end
