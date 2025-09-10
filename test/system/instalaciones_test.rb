require "application_system_test_case"

class InstalacionsTest < ApplicationSystemTestCase
  setup do
    @instalacion = instalacions(:one)
  end

  test "visiting the index" do
    visit instalacions_url
    assert_selector "h1", text: "Instalacions"
  end

  test "should create instalacion" do
    visit instalacions_url
    click_on "New instalacion"

    fill_in "Adress", with: @instalacion.adress
    fill_in "Customer name", with: @instalacion.customer_name
    fill_in "Date", with: @instalacion.date
    fill_in "Duration", with: @instalacion.duration
    fill_in "Int", with: @instalacion.int
    fill_in "Start time", with: @instalacion.start_time
    fill_in "String", with: @instalacion.string
    fill_in "Tecnico", with: @instalacion.tecnico_id
    fill_in "Time", with: @instalacion.time
    click_on "Create Instalacion"

    assert_text "Instalacion was successfully created"
    click_on "Back"
  end

  test "should update Instalacion" do
    visit instalacion_url(@instalacion)
    click_on "Edit this instalacion", match: :first

    fill_in "Adress", with: @instalacion.adress
    fill_in "Customer name", with: @instalacion.customer_name
    fill_in "Date", with: @instalacion.date
    fill_in "Duration", with: @instalacion.duration
    fill_in "Int", with: @instalacion.int
    fill_in "Start time", with: @instalacion.start_time
    fill_in "String", with: @instalacion.string
    fill_in "Tecnico", with: @instalacion.tecnico_id
    fill_in "Time", with: @instalacion.time
    click_on "Update Instalacion"

    assert_text "Instalacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Instalacion" do
    visit instalacion_url(@instalacion)
    click_on "Destroy this instalacion", match: :first

    assert_text "Instalacion was successfully destroyed"
  end
end
