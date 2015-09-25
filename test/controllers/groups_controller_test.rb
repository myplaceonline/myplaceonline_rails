require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { group_name: "test" }
  end
end
