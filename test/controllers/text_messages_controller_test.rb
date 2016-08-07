require 'test_helper'

class TextMessagesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { body: "test", message_category: "test" }
  end
end
