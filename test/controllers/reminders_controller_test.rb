require 'test_helper'

class RemindersControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { start_time: Time.now }
  end
end
