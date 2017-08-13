require 'test_helper'

class ImportsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { import_name: "test" }
  end
end
