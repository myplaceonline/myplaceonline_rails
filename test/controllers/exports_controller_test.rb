require 'test_helper'

class ExportsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { export_name: "test", export_type: 0 }
  end
end
