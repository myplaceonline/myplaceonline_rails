require 'test_helper'

class BillsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { bill_name: "test" }
  end
end
