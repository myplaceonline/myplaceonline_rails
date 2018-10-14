require 'test_helper'

class CreditReportsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { credit_report_description: "test", credit_report_date: Date.today }
  end
end
