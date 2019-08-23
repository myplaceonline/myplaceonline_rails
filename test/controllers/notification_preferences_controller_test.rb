require 'test_helper'

class TestObjectsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { notification_type: 1 }
  end
end
