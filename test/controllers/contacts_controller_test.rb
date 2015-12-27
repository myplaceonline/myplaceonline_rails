require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { identity_attributes: { name: "Test" } }
  end

  def do_test_delete
    false
  end
end
