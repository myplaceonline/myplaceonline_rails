require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { identity_attributes: { name: "Test" } }
  end
end
