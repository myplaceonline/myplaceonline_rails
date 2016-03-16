require 'test_helper'

class QuestsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { quest_title: "test" }
  end
end
