require 'test_helper'

class PassportsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { region: "test", passport_number: "test" }
  end
end
