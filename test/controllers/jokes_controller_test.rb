require 'test_helper'

class JokesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def model
    Joke
  end
  
  def test_attributes
    { name: "test" }
  end
end
