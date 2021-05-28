require 'test_helper'

class MemesControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { meme_name: "test" }
  end
end
