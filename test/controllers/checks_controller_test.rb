require 'test_helper'

class ChecksControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { description: "test" }
  end
end
