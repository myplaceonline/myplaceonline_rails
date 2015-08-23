require 'test_helper'

class WebsitesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { url: "https://myplaceonline.com/" }
  end
end
