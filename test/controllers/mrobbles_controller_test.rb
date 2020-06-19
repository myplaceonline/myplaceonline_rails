require 'test_helper'

class MrobblesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { mrobble_name: "test" }
  end
end
