require 'test_helper'

class DisappearingMessagesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { name: "test", notes: "test" }
  end
end
