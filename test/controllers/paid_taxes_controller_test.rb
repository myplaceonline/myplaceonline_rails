require 'test_helper'

class PaidTaxesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { fiscal_year: 2001 }
  end
end
