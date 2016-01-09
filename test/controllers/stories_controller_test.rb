require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { story_name: "test", story_time: Time.now }
  end
end
