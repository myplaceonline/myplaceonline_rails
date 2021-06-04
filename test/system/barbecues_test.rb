require "application_system_test_case"

class BarbecuesTest < ApplicationSystemTestCase
  setup do
    @barbecue = barbecues(:one)
  end

  test "visiting the index" do
    visit barbecues_url
    assert_selector "h1", text: "Barbecues"
  end

  test "creating a Barbecue" do
    visit barbecues_url
    click_on "New Barbecue"

    fill_in "Archived", with: @barbecue.archived
    fill_in "Identity", with: @barbecue.identity_id
    check "Is public" if @barbecue.is_public
    fill_in "Location", with: @barbecue.location_id
    fill_in "Notes", with: @barbecue.notes
    fill_in "Rating", with: @barbecue.rating
    fill_in "Visit count", with: @barbecue.visit_count
    click_on "Create Barbecue"

    assert_text "Barbecue was successfully created"
    click_on "Back"
  end

  test "updating a Barbecue" do
    visit barbecues_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @barbecue.archived
    fill_in "Identity", with: @barbecue.identity_id
    check "Is public" if @barbecue.is_public
    fill_in "Location", with: @barbecue.location_id
    fill_in "Notes", with: @barbecue.notes
    fill_in "Rating", with: @barbecue.rating
    fill_in "Visit count", with: @barbecue.visit_count
    click_on "Update Barbecue"

    assert_text "Barbecue was successfully updated"
    click_on "Back"
  end

  test "destroying a Barbecue" do
    visit barbecues_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Barbecue was successfully destroyed"
  end
end
