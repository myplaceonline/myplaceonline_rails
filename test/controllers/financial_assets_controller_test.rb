require 'test_helper'

class FinancialAssetsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { asset_name: "test", asset_value: 0 }
  end
end
