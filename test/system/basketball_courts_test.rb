require "application_system_test_case"

class BasketballCourtsTest < ApplicationSystemTestCase
  setup do
    @basketball_court = basketball_courts(:one)
  end

  test "visiting the index" do
    visit basketball_courts_url
    assert_selector "h1", text: "Basketball Courts"
  end

  test "creating a Basketball court" do
    visit basketball_courts_url
    click_on "New Basketball Court"

    fill_in "Archived", with: @basketball_court.archived
    fill_in "Identity", with: @basketball_court.identity_id
    check "Is public" if @basketball_court.is_public
    fill_in "Location", with: @basketball_court.location_id
    fill_in "Notes", with: @basketball_court.notes
    fill_in "Rating", with: @basketball_court.rating
    fill_in "Visit count", with: @basketball_court.visit_count
    click_on "Create Basketball court"

    assert_text "Basketball court was successfully created"
    click_on "Back"
  end

  test "updating a Basketball court" do
    visit basketball_courts_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @basketball_court.archived
    fill_in "Identity", with: @basketball_court.identity_id
    check "Is public" if @basketball_court.is_public
    fill_in "Location", with: @basketball_court.location_id
    fill_in "Notes", with: @basketball_court.notes
    fill_in "Rating", with: @basketball_court.rating
    fill_in "Visit count", with: @basketball_court.visit_count
    click_on "Update Basketball court"

    assert_text "Basketball court was successfully updated"
    click_on "Back"
  end

  test "destroying a Basketball court" do
    visit basketball_courts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Basketball court was successfully destroyed"
  end
end
