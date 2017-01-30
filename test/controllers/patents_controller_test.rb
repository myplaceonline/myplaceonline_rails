require 'test_helper'

class PatentsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { patent_name: "test" }
  end
end
