require 'test_helper'

class ComputerEnvironmentsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { computer_environment_name: "test" }
  end
end
