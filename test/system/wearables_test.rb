require "application_system_test_case"

class WearablesTest < ApplicationSystemTestCase
  setup do
    @wearable = wearables(:one)
  end

  test "visiting the index" do
    visit wearables_url
    assert_selector "h1", text: "Wearables"
  end

  test "creating a Wearable" do
    visit wearables_url
    click_on "New Wearable"

    fill_in "Archived", with: @wearable.archived
    fill_in "Identity", with: @wearable.identity_id
    check "Is public" if @wearable.is_public
    fill_in "Name", with: @wearable.name
    fill_in "Notes", with: @wearable.notes
    fill_in "Rating", with: @wearable.rating
    fill_in "Visit count", with: @wearable.visit_count
    click_on "Create Wearable"

    assert_text "Wearable was successfully created"
    click_on "Back"
  end

  test "updating a Wearable" do
    visit wearables_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @wearable.archived
    fill_in "Identity", with: @wearable.identity_id
    check "Is public" if @wearable.is_public
    fill_in "Name", with: @wearable.name
    fill_in "Notes", with: @wearable.notes
    fill_in "Rating", with: @wearable.rating
    fill_in "Visit count", with: @wearable.visit_count
    click_on "Update Wearable"

    assert_text "Wearable was successfully updated"
    click_on "Back"
  end

  test "destroying a Wearable" do
    visit wearables_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Wearable was successfully destroyed"
  end
end
