require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Song
  end
  
  def test_attributes
    { song_name: "test" }
  end
end
