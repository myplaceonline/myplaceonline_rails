require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Feed
  end
  
  def test_attributes
    { name: "test", url: "https://myplaceonline.com/" }
  end
end
