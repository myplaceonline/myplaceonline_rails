require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { document_name: "test" }
  end
end
