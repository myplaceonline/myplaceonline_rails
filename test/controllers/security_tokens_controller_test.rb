require 'test_helper'

class SecurityTokensControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { security_token_value: "test" }
  end
end
