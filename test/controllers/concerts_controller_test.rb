require 'test_helper'

class ConcertsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { concert_date: DateTime.now, concert_title: "Test" }
  end
end
