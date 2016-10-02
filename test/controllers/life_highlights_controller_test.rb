require 'test_helper'

class LifeHighlightsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { life_highlight_name: "test" }
  end
end
