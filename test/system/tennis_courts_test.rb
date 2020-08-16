require "application_system_test_case"

class TennisCourtsTest < ApplicationSystemTestCase
  setup do
    @tennis_court = tennis_courts(:one)
  end

  test "visiting the index" do
    visit tennis_courts_url
    assert_selector "h1", text: "Tennis Courts"
  end

  test "creating a Tennis court" do
    visit tennis_courts_url
    click_on "New Tennis Court"

    fill_in "Archived", with: @tennis_court.archived
    fill_in "Identity", with: @tennis_court.identity_id
    check "Is public" if @tennis_court.is_public
    fill_in "Location", with: @tennis_court.location_id
    fill_in "Notes", with: @tennis_court.notes
    fill_in "Rating", with: @tennis_court.rating
    fill_in "Visit count", with: @tennis_court.visit_count
    click_on "Create Tennis court"

    assert_text "Tennis court was successfully created"
    click_on "Back"
  end

  test "updating a Tennis court" do
    visit tennis_courts_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @tennis_court.archived
    fill_in "Identity", with: @tennis_court.identity_id
    check "Is public" if @tennis_court.is_public
    fill_in "Location", with: @tennis_court.location_id
    fill_in "Notes", with: @tennis_court.notes
    fill_in "Rating", with: @tennis_court.rating
    fill_in "Visit count", with: @tennis_court.visit_count
    click_on "Update Tennis court"

    assert_text "Tennis court was successfully updated"
    click_on "Back"
  end

  test "destroying a Tennis court" do
    visit tennis_courts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tennis court was successfully destroyed"
  end
end
