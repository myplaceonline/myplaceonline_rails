require 'test_helper'

class PlaylistsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { playlist_name: "test" }
  end
end
