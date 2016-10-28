require 'test_helper'

class RetirementPlansControllerTest < ActionController::TestCase
  setup do
    @retirement_plan = retirement_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retirement_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retirement_plan" do
    assert_difference('RetirementPlan.count') do
      post :create, retirement_plan: { archived: @retirement_plan.archived, company_id: @retirement_plan.company_id, identity_id: @retirement_plan.identity_id, notes: @retirement_plan.notes, password_id: @retirement_plan.password_id, periodic_payment_id: @retirement_plan.periodic_payment_id, rating: @retirement_plan.rating, retirement_plan_name: @retirement_plan.retirement_plan_name, retirement_plan_type: @retirement_plan.retirement_plan_type, started: @retirement_plan.started, visit_count: @retirement_plan.visit_count }
    end

    assert_redirected_to retirement_plan_path(assigns(:retirement_plan))
  end

  test "should show retirement_plan" do
    get :show, id: @retirement_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @retirement_plan
    assert_response :success
  end

  test "should update retirement_plan" do
    patch :update, id: @retirement_plan, retirement_plan: { archived: @retirement_plan.archived, company_id: @retirement_plan.company_id, identity_id: @retirement_plan.identity_id, notes: @retirement_plan.notes, password_id: @retirement_plan.password_id, periodic_payment_id: @retirement_plan.periodic_payment_id, rating: @retirement_plan.rating, retirement_plan_name: @retirement_plan.retirement_plan_name, retirement_plan_type: @retirement_plan.retirement_plan_type, started: @retirement_plan.started, visit_count: @retirement_plan.visit_count }
    assert_redirected_to retirement_plan_path(assigns(:retirement_plan))
  end

  test "should destroy retirement_plan" do
    assert_difference('RetirementPlan.count', -1) do
      delete :destroy, id: @retirement_plan
    end

    assert_redirected_to retirement_plans_path
  end
end
