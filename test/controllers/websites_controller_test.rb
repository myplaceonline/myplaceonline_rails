require 'test_helper'

class WebsitesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Website
  end
  
  def test_attributes
    { url: "https://myplaceonline.com/" }
  end
end
