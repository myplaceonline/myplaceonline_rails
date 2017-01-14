require 'test_helper'

class TaxDocumentsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { tax_document_form_name: "test" }
  end
end
