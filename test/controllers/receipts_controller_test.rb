require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { receipt_name: "test", receipt_time: Time.now }
  end
end
