require "application_system_test_case"

class VehicleWashesTest < ApplicationSystemTestCase
  setup do
    @vehicle_wash = vehicle_washes(:one)
  end

  test "visiting the index" do
    visit vehicle_washes_url
    assert_selector "h1", text: "Vehicle Washes"
  end

  test "creating a Vehicle wash" do
    visit vehicle_washes_url
    click_on "New Vehicle Wash"

    fill_in "Archived", with: @vehicle_wash.archived
    fill_in "Identity", with: @vehicle_wash.identity_id
    check "Is public" if @vehicle_wash.is_public
    fill_in "Location", with: @vehicle_wash.location_id
    fill_in "Notes", with: @vehicle_wash.notes
    fill_in "Rating", with: @vehicle_wash.rating
    fill_in "Visit count", with: @vehicle_wash.visit_count
    click_on "Create Vehicle wash"

    assert_text "Vehicle wash was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle wash" do
    visit vehicle_washes_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @vehicle_wash.archived
    fill_in "Identity", with: @vehicle_wash.identity_id
    check "Is public" if @vehicle_wash.is_public
    fill_in "Location", with: @vehicle_wash.location_id
    fill_in "Notes", with: @vehicle_wash.notes
    fill_in "Rating", with: @vehicle_wash.rating
    fill_in "Visit count", with: @vehicle_wash.visit_count
    click_on "Update Vehicle wash"

    assert_text "Vehicle wash was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle wash" do
    visit vehicle_washes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle wash was successfully destroyed"
  end
end
