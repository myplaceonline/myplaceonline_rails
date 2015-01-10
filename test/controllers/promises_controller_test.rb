require 'test_helper'

class PromisesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Promise
  end
  
  def test_attributes
    { name: "test" }
  end
end
