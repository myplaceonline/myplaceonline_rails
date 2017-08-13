require 'test_helper'

class BlogsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { blog_name: "test" }
  end
end
