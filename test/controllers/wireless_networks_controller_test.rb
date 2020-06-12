require 'test_helper'

class WirelessNetworksControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { network_names: "test" }
  end
end
