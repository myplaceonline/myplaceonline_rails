require 'test_helper'

class ArtsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { art_name: "test" }
  end
end
