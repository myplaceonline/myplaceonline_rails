require 'test_helper'

class AgentsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { agent_identity_attributes: { name: "Test" } }
  end

  def do_test_delete
    false
  end
end
