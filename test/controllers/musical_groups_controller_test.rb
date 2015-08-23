require 'test_helper'

class MusicalGroupsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { musical_group_name: "test" }
  end
end
