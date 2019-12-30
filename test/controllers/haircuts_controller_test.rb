require 'test_helper'

class HaircutsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { haircut_time: DateTime.now }
  end
end
