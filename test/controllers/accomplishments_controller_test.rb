require 'test_helper'

class AccomplishmentsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Accomplishment
  end
  
  def test_attributes
    { name: "test" }
  end
end
