require 'test_helper'

class SiteInvoicesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { invoice_time: Time.now, invoice_amount: 1.00, invoice_status: 0 }
  end
end
