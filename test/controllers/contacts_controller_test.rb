require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Contact
  end
  
  def test_attributes
    { ref_attributes: { name: "Test" } }
  end
end
