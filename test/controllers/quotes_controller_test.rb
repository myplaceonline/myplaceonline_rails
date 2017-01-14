require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { quote_text: "test" }
  end
end
