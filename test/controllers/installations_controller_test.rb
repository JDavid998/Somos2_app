require "test_helper"

class InstallationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get installations_index_url
    assert_response :success
  end

  test "should get show" do
    get installations_show_url
    assert_response :success
  end

  test "should get new" do
    get installations_new_url
    assert_response :success
  end

  test "should get create" do
    get installations_create_url
    assert_response :success
  end

  test "should get edit" do
    get installations_edit_url
    assert_response :success
  end

  test "should get update" do
    get installations_update_url
    assert_response :success
  end

  test "should get destroy" do
    get installations_destroy_url
    assert_response :success
  end

  test "should get assign" do
    get installations_assign_url
    assert_response :success
  end
end
