require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { name: "test" }
  end
end
