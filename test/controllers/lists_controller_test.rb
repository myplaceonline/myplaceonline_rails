require 'test_helper'

class ListsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    List
  end
  
  def test_attributes
    { name: "test" }
  end
end
