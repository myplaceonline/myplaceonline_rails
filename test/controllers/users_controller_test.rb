require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    super
    @controller = Users::RegistrationsController.new
  end
  
  test "should get export.js" do
    @request.env["HTTP_ACCEPT"] = 'application/json'
    get :export, params: { encrypt: "0" }
    assert_response :success
  end
end
