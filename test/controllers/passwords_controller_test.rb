require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Password
  end
  
  def test_attributes
    { name: "test" }
  end
end
