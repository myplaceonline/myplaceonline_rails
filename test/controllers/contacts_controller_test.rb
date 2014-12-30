require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Contact
  end
  
  def test_attributes
    { created_at: Time.now }
  end
end
