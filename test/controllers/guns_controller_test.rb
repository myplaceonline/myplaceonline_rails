require 'test_helper'

class GunsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { gun_name: "test" }
  end
end
