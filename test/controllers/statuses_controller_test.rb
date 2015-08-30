require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { status_time: DateTime.now }
  end
end
