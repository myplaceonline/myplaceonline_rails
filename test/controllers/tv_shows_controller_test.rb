require 'test_helper'

class TvShowsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { tv_show_name: "test" }
  end
end
