require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { notification_subject: "test", notification_text: "test", notification_type: 1 }
  end
end
