require 'test_helper'

class MeaningControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
