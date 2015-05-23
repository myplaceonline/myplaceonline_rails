require 'test_helper'

class ChecklistsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Checklist
  end
  
  def test_attributes
    { checklist_name: "test" }
  end
end
