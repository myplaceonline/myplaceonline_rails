require 'test_helper'

class HeadachesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { started: DateTime.now }
  end
end
