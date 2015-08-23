require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { book_name: "test" }
  end
end
