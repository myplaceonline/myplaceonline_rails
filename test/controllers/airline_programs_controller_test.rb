require 'test_helper'

class AirlineProgramsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { program_name: "test" }
  end
end
