require 'test_helper'

class CreditReportsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { credit_report_date: Date.today, credit_reporting_agency: 1 }
  end
end
