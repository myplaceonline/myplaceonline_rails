require 'test_helper'

class MusicAlbumsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { music_album_name: "test" }
  end
end
