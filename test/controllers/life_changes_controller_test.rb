require 'test_helper'

class LifeChangesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { life_change_title: "test" }
  end
end
