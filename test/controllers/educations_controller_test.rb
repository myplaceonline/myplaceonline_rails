require 'test_helper'

class EducationsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { education_name: "test", education_end: Date.today }
  end
end
