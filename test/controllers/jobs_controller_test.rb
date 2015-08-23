require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { job_title: "test" }
  end
end
