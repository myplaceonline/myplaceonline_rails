require 'test_helper'

class DraftsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { draft_name: "test" }
  end
end
