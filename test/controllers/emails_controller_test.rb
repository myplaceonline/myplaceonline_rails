require 'test_helper'

class EmailsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { subject: "test", body: "test", email_category: "category" }
  end
end
