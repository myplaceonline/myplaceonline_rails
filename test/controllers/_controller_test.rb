require 'test_helper'

class TestObjectsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { test_object_name: "test" }
  end
end
