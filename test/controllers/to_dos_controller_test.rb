require 'test_helper'

class ToDosControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { short_description: "test" }
  end
end
