require 'test_helper'

class CrontabsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { crontab_name: "test" }
  end
end
