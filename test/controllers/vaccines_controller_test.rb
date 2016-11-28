require 'test_helper'

class VaccinesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { vaccine_name: "test" }
  end
end
