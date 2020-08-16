require "application_system_test_case"

class SoccerFieldsTest < ApplicationSystemTestCase
  setup do
    @soccer_field = soccer_fields(:one)
  end

  test "visiting the index" do
    visit soccer_fields_url
    assert_selector "h1", text: "Soccer Fields"
  end

  test "creating a Soccer field" do
    visit soccer_fields_url
    click_on "New Soccer Field"

    fill_in "Archived", with: @soccer_field.archived
    fill_in "Identity", with: @soccer_field.identity_id
    check "Is public" if @soccer_field.is_public
    fill_in "Location", with: @soccer_field.location_id
    fill_in "Notes", with: @soccer_field.notes
    fill_in "Rating", with: @soccer_field.rating
    fill_in "Visit count", with: @soccer_field.visit_count
    click_on "Create Soccer field"

    assert_text "Soccer field was successfully created"
    click_on "Back"
  end

  test "updating a Soccer field" do
    visit soccer_fields_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @soccer_field.archived
    fill_in "Identity", with: @soccer_field.identity_id
    check "Is public" if @soccer_field.is_public
    fill_in "Location", with: @soccer_field.location_id
    fill_in "Notes", with: @soccer_field.notes
    fill_in "Rating", with: @soccer_field.rating
    fill_in "Visit count", with: @soccer_field.visit_count
    click_on "Update Soccer field"

    assert_text "Soccer field was successfully updated"
    click_on "Back"
  end

  test "destroying a Soccer field" do
    visit soccer_fields_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Soccer field was successfully destroyed"
  end
end
