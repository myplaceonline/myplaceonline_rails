require 'test_helper'

class DatingProfilesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { dating_profile_name: "test" }
  end
end
