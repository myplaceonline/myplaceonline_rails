require 'test_helper'

class WorkControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
