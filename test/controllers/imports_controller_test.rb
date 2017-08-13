require 'test_helper'

class ImportsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { import_name: "test", import_type: 0 }
  end
end
