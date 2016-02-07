require 'test_helper'

class WebsitesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { title: "Myplaceonline", url: "https://myplaceonline.com/" }
  end
end
