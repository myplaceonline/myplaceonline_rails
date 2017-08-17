require 'test_helper'

class TranslationsControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { translation_input: "test", translation_output: "Test" }
  end
end
