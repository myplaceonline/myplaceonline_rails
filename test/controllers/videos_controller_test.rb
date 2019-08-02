require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { video_name: "test" }
  end
end
