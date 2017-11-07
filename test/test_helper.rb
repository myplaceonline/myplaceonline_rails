ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  
  self.use_transactional_tests = true
  
  Rails.logger.info{"Test Helper initializing"}
  
  Rails.logger.info{"Myplaceonline tests started with #{Myp.categories.length} categories"}
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  Rails.logger.info{"Fixtures loaded"}
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    Rails.logger.info{"Starting test for #{self.class}"}
    Rails.application.load_seed
    Rails.logger.info{"Finished loading seeds"}
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:user)
    @identity = identities(:identity)
    MyplaceonlineExecutionContext.do_user(@user) do
      User.post_initialize_identity(@user, @identity)
    end
    Rails.logger.info{"Post-initialized #{@user.inspect}"}
    ExecutionContext.clear
    ExecutionContext.push
    MyplaceonlineExecutionContext.initialize(
      request: @request,
      session: session,
      user: @user,
      persistent_user_store: InMemoryPersistentUserStore.new
    )
    MyplaceonlineExecutionContext.initialized = true
    Myp.persist_password("password")
    @user.confirm
    sign_in @user
    Rails.logger.info{"Setup complete"}
  end
end

module MyplaceonlineControllerTest
  extend ActiveSupport::Testing::Declarative
  
  def model
    Object.const_get(self.class.name.gsub(/ControllerTest$/, "").singularize)
  end
  
  def test_attributes
    raise NotImplementedError
  end
  
  def do_test_delete
    false
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
        post :create, params: { model.model_name.singular.downcase => attrs.merge({ identity_id: @user.current_identity_id }) }
      end

      assert_redirected_to send(model.model_name.singular.downcase + "_path", assigns(:obj))
    end
  end

  test "should show" do
    get :show, params: { id: send(model.table_name, model.model_name.singular.downcase) }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: send(model.table_name, model.model_name.singular.downcase) }
    assert_response :success
  end

  test "should update" do
    attrs = test_attributes
    if attrs.length > 0
      patch :update, params: { id: send(model.table_name, model.model_name.singular.downcase), model.model_name.singular.downcase => test_attributes }
      assert_redirected_to send(model.model_name.singular.downcase + "_path", assigns(:obj))
    end
  end

  test "should destroy" do
    # This ends up deleting constraints because we just use the same one everywhere
    # so need to figure that out
    if do_test_delete
      assert_difference(model.name + '.count', -1) do
        delete :destroy, params: { id: send(model.table_name, model.model_name.singular.downcase) }
      end

      assert_redirected_to send(model.table_name + "_path")
    end
  end
end
