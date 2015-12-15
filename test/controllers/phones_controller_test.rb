require 'test_helper'

class PhonesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { phone_model_name: "test" }
  end
end
