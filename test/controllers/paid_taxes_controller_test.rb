require 'test_helper'

class PaidTaxesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { paid_tax_description: "test", paid_tax_date: Date.today }
  end
end
