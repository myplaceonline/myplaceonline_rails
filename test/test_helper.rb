ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:user)
    User.current_user = @user
    Myp.remember_password(session, "password")
    @user.confirm
    @user.primary_identity.ensure_contact!
    sign_in @user
  end
end

module MyplaceonlineControllerTest
  extend ActiveSupport::Testing::Declarative
  
  def model
    raise NotImplementedError
  end
  
  def model
    Object.const_get(self.class.name.gsub(/ControllerTest$/, "").singularize)
  end
  
  def test_attributes
    raise NotImplementedError
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:objs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    attrs = test_attributes
    if attrs.length > 0
      assert_difference(model.name + '.count') do
        post :create, model.model_name.singular.downcase => attrs.merge({ owner_id: @user.primary_identity_id })
      end

      assert_redirected_to send(model.model_name.singular.downcase + "_path", assigns(:obj))
    end
  end

  test "should show" do
    get :show, id: send(model.table_name, model.model_name.singular.downcase)
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: send(model.table_name, model.model_name.singular.downcase)
    assert_response :success
  end

  test "should update" do
    attrs = test_attributes
    if attrs.length > 0
      patch :update, id: send(model.table_name, model.model_name.singular.downcase), model.model_name.singular.downcase => test_attributes
      assert_redirected_to send(model.model_name.singular.downcase + "_path", assigns(:obj))
    end
  end

  test "should destroy" do
    assert_difference(model.name + '.count', -1) do
      delete :destroy, id: send(model.table_name, model.model_name.singular.downcase)
    end

    assert_redirected_to send(model.table_name + "_path")
  end
end
