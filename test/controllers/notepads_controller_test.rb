require 'test_helper'

class NotepadsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { title: "test" }
  end
end
