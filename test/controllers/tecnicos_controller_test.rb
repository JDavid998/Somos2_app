require "test_helper"

class TecnicosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tecnico = tecnicos(:one)
  end

  test "should get index" do
    get tecnicos_url
    assert_response :success
  end

  test "should get new" do
    get new_tecnico_url
    assert_response :success
  end

  test "should create tecnico" do
    assert_difference("Tecnico.count") do
      post tecnicos_url, params: { tecnico: { email: @tecnico.email, name: @tecnico.name, string: @tecnico.string } }
    end

    assert_redirected_to tecnico_url(Tecnico.last)
  end

  test "should show tecnico" do
    get tecnico_url(@tecnico)
    assert_response :success
  end

  test "should get edit" do
    get edit_tecnico_url(@tecnico)
    assert_response :success
  end

  test "should update tecnico" do
    patch tecnico_url(@tecnico), params: { tecnico: { email: @tecnico.email, name: @tecnico.name, string: @tecnico.string } }
    assert_redirected_to tecnico_url(@tecnico)
  end

  test "should destroy tecnico" do
    assert_difference("Tecnico.count", -1) do
      delete tecnico_url(@tecnico)
    end

    assert_redirected_to tecnicos_url
  end
end
