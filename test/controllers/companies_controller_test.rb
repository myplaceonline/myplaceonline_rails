require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { name: "Test" }
  end
end
