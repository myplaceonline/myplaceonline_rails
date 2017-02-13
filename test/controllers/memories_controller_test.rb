require 'test_helper'

class MemoriesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { memory_name: "test" }
  end
end
