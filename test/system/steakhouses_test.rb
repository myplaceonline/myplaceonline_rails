require "application_system_test_case"

class SteakhousesTest < ApplicationSystemTestCase
  setup do
    @steakhouse = steakhouses(:one)
  end

  test "visiting the index" do
    visit steakhouses_url
    assert_selector "h1", text: "Steakhouses"
  end

  test "creating a Steakhouse" do
    visit steakhouses_url
    click_on "New Steakhouse"

    fill_in "Archived", with: @steakhouse.archived
    fill_in "Identity", with: @steakhouse.identity_id
    check "Is public" if @steakhouse.is_public
    fill_in "Location", with: @steakhouse.location_id
    fill_in "Notes", with: @steakhouse.notes
    fill_in "Rating", with: @steakhouse.rating
    fill_in "Visit count", with: @steakhouse.visit_count
    click_on "Create Steakhouse"

    assert_text "Steakhouse was successfully created"
    click_on "Back"
  end

  test "updating a Steakhouse" do
    visit steakhouses_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @steakhouse.archived
    fill_in "Identity", with: @steakhouse.identity_id
    check "Is public" if @steakhouse.is_public
    fill_in "Location", with: @steakhouse.location_id
    fill_in "Notes", with: @steakhouse.notes
    fill_in "Rating", with: @steakhouse.rating
    fill_in "Visit count", with: @steakhouse.visit_count
    click_on "Update Steakhouse"

    assert_text "Steakhouse was successfully updated"
    click_on "Back"
  end

  test "destroying a Steakhouse" do
    visit steakhouses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Steakhouse was successfully destroyed"
  end
end
