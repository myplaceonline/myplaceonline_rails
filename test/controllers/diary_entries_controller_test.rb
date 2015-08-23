require 'test_helper'

class DiaryEntriesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { diary_time: Time.now, entry: "test" }
  end
end
