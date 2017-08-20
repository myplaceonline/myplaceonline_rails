require 'test_helper'

class BoycottsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { boycott_name: "test" }
  end
end
