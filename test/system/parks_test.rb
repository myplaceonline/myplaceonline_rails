require "application_system_test_case"

class ParksTest < ApplicationSystemTestCase
  setup do
    @park = parks(:one)
  end

  test "visiting the index" do
    visit parks_url
    assert_selector "h1", text: "Parks"
  end

  test "creating a Park" do
    visit parks_url
    click_on "New Park"

    check "Allows drinking" if @park.allows_drinking
    fill_in "Archived", with: @park.archived
    fill_in "Drinking times", with: @park.drinking_times
    fill_in "Identity", with: @park.identity_id
    check "Is public" if @park.is_public
    fill_in "Location", with: @park.location_id
    fill_in "Notes", with: @park.notes
    fill_in "Rating", with: @park.rating
    fill_in "Visit count", with: @park.visit_count
    click_on "Create Park"

    assert_text "Park was successfully created"
    click_on "Back"
  end

  test "updating a Park" do
    visit parks_url
    click_on "Edit", match: :first

    check "Allows drinking" if @park.allows_drinking
    fill_in "Archived", with: @park.archived
    fill_in "Drinking times", with: @park.drinking_times
    fill_in "Identity", with: @park.identity_id
    check "Is public" if @park.is_public
    fill_in "Location", with: @park.location_id
    fill_in "Notes", with: @park.notes
    fill_in "Rating", with: @park.rating
    fill_in "Visit count", with: @park.visit_count
    click_on "Update Park"

    assert_text "Park was successfully updated"
    click_on "Back"
  end

  test "destroying a Park" do
    visit parks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Park was successfully destroyed"
  end
end
