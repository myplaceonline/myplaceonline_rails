require 'test_helper'

class RemindersControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { start_time: Time.now, reminder_name: "Test" }
  end
end
