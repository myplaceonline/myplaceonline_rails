require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Subscription
  end
  
  def test_attributes
    { name: "test" }
  end
end
