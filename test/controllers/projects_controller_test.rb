require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { project_name: "test" }
  end
end
