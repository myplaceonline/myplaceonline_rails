require 'test_helper'
require 'factory_girl_rails'

class MoviesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Movie
  end
  
  def test_attributes
    { name: "test" }
  end
end
