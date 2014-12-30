require 'test_helper'
require 'factory_girl_rails'

class MoviesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Movie
  end
end
