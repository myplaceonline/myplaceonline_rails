require 'test_helper'

class MediaDumpsControllerTest < ActionController::TestCase
  setup do
    @media_dump = media_dumps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_dumps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_dump" do
    assert_difference('MediaDump.count') do
      post :create, media_dump: { identity_id: @media_dump.identity_id, media_dump_name: @media_dump.media_dump_name, notes: @media_dump.notes, visit_count: @media_dump.visit_count }
    end

    assert_redirected_to media_dump_path(assigns(:media_dump))
  end

  test "should show media_dump" do
    get :show, id: @media_dump
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_dump
    assert_response :success
  end

  test "should update media_dump" do
    patch :update, id: @media_dump, media_dump: { identity_id: @media_dump.identity_id, media_dump_name: @media_dump.media_dump_name, notes: @media_dump.notes, visit_count: @media_dump.visit_count }
    assert_redirected_to media_dump_path(assigns(:media_dump))
  end

  test "should destroy media_dump" do
    assert_difference('MediaDump.count', -1) do
      delete :destroy, id: @media_dump
    end

    assert_redirected_to media_dumps_path
  end
end
