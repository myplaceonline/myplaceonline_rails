require 'test_helper'

class SavedGamesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { game_name: "test" }
  end
end
