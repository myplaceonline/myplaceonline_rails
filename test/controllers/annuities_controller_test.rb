require 'test_helper'

class AnnuitiesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { annuity_name: "test" }
  end
end
