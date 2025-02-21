require 'test_helper'

class WhatdidiwearthensControllerTest < ActionController::TestCase
  include MyplaceonlineControllerTest
  
  def test_attributes
    { weartime: DateTime.now }
  end
end
