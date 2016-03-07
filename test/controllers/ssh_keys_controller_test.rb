require 'test_helper'

class SshKeysControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { ssh_key_name: "test", ssh_private_key: "test", ssh_public_key: "test" }
  end
end
