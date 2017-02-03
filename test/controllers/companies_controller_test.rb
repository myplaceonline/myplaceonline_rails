require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { company_identity_attributes: { name: "Test" } }
  end

  def do_test_delete
    false
  end
end
