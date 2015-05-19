require 'test_helper'

class PainsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Pain
  end
  
  def test_attributes
    { pain_start_time: DateTime.now }
  end
end
