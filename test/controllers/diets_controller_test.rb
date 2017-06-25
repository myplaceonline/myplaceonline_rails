require 'test_helper'

class DietsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @diet = diets(:one)
  end

  test "should get index" do
    get diets_url
    assert_response :success
  end

  test "should get new" do
    get new_diet_url
    assert_response :success
  end

  test "should create diet" do
    assert_difference('Diet.count') do
      post diets_url, params: { diet: { archived: @diet.archived, diet_name: @diet.diet_name, dietary_requirement_id: @diet.dietary_requirement_id, identity_id: @diet.identity_id, notes: @diet.notes, rating: @diet.rating, visit_count: @diet.visit_count } }
    end

    assert_redirected_to diet_url(Diet.last)
  end

  test "should show diet" do
    get diet_url(@diet)
    assert_response :success
  end

  test "should get edit" do
    get edit_diet_url(@diet)
    assert_response :success
  end

  test "should update diet" do
    patch diet_url(@diet), params: { diet: { archived: @diet.archived, diet_name: @diet.diet_name, dietary_requirement_id: @diet.dietary_requirement_id, identity_id: @diet.identity_id, notes: @diet.notes, rating: @diet.rating, visit_count: @diet.visit_count } }
    assert_redirected_to diet_url(@diet)
  end

  test "should destroy diet" do
    assert_difference('Diet.count', -1) do
      delete diet_url(@diet)
    end

    assert_redirected_to diets_url
  end
end
