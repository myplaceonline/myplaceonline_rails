require "application_system_test_case"

class HaircutsTest < ApplicationSystemTestCase
  setup do
    @haircut = haircuts(:one)
  end

  test "visiting the index" do
    visit haircuts_url
    assert_selector "h1", text: "Haircuts"
  end

  test "creating a Haircut" do
    visit haircuts_url
    click_on "New Haircut"

    fill_in "Archived", with: @haircut.archived
    fill_in "Cutter", with: @haircut.cutter_id
    fill_in "Haircut time", with: @haircut.haircut_time
    fill_in "Identity", with: @haircut.identity_id
    check "Is public" if @haircut.is_public
    fill_in "Location", with: @haircut.location_id
    fill_in "Notes", with: @haircut.notes
    fill_in "Rating", with: @haircut.rating
    fill_in "Total cost", with: @haircut.total_cost
    fill_in "Visit count", with: @haircut.visit_count
    click_on "Create Haircut"

    assert_text "Haircut was successfully created"
    click_on "Back"
  end

  test "updating a Haircut" do
    visit haircuts_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @haircut.archived
    fill_in "Cutter", with: @haircut.cutter_id
    fill_in "Haircut time", with: @haircut.haircut_time
    fill_in "Identity", with: @haircut.identity_id
    check "Is public" if @haircut.is_public
    fill_in "Location", with: @haircut.location_id
    fill_in "Notes", with: @haircut.notes
    fill_in "Rating", with: @haircut.rating
    fill_in "Total cost", with: @haircut.total_cost
    fill_in "Visit count", with: @haircut.visit_count
    click_on "Update Haircut"

    assert_text "Haircut was successfully updated"
    click_on "Back"
  end

  test "destroying a Haircut" do
    visit haircuts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Haircut was successfully destroyed"
  end
end
