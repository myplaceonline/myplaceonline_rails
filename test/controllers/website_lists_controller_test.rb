require 'test_helper'

class WebsiteListsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { website_list_name: "test" }
  end
end
