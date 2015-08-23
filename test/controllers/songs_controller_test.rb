require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { song_name: "test" }
  end
end
