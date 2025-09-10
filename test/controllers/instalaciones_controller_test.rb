require "test_helper"

class InstalacionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @instalacion = instalacions(:one)
  end

  test "should get index" do
    get instalacions_url
    assert_response :success
  end

  test "should get new" do
    get new_instalacion_url
    assert_response :success
  end

  test "should create instalacion" do
    assert_difference("Instalacion.count") do
      post instalacions_url, params: { instalacion: { adress: @instalacion.adress, customer_name: @instalacion.customer_name, date: @instalacion.date, duration: @instalacion.duration, int: @instalacion.int, start_time: @instalacion.start_time, string: @instalacion.string, tecnico_id: @instalacion.tecnico_id, time: @instalacion.time } }
    end

    assert_redirected_to instalacion_url(Instalacion.last)
  end

  test "should show instalacion" do
    get instalacion_url(@instalacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_instalacion_url(@instalacion)
    assert_response :success
  end

  test "should update instalacion" do
    patch instalacion_url(@instalacion), params: { instalacion: { adress: @instalacion.adress, customer_name: @instalacion.customer_name, date: @instalacion.date, duration: @instalacion.duration, int: @instalacion.int, start_time: @instalacion.start_time, string: @instalacion.string, tecnico_id: @instalacion.tecnico_id, time: @instalacion.time } }
    assert_redirected_to instalacion_url(@instalacion)
  end

  test "should destroy instalacion" do
    assert_difference("Instalacion.count", -1) do
      delete instalacion_url(@instalacion)
    end

    assert_redirected_to instalacions_url
  end
end
