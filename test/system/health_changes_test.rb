require "application_system_test_case"

class HealthChangesTest < ApplicationSystemTestCase
  setup do
    @health_change = health_changes(:one)
  end

  test "visiting the index" do
    visit health_changes_url
    assert_selector "h1", text: "Health Changes"
  end

  test "creating a Health change" do
    visit health_changes_url
    click_on "New Health Change"

    fill_in "Archived", with: @health_change.archived
    fill_in "Change date", with: @health_change.change_date
    fill_in "Change name", with: @health_change.change_name
    fill_in "Identity", with: @health_change.identity_id
    check "Is public" if @health_change.is_public
    fill_in "Notes", with: @health_change.notes
    fill_in "Rating", with: @health_change.rating
    fill_in "Visit count", with: @health_change.visit_count
    click_on "Create Health change"

    assert_text "Health change was successfully created"
    click_on "Back"
  end

  test "updating a Health change" do
    visit health_changes_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @health_change.archived
    fill_in "Change date", with: @health_change.change_date
    fill_in "Change name", with: @health_change.change_name
    fill_in "Identity", with: @health_change.identity_id
    check "Is public" if @health_change.is_public
    fill_in "Notes", with: @health_change.notes
    fill_in "Rating", with: @health_change.rating
    fill_in "Visit count", with: @health_change.visit_count
    click_on "Update Health change"

    assert_text "Health change was successfully updated"
    click_on "Back"
  end

  test "destroying a Health change" do
    visit health_changes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Health change was successfully destroyed"
  end
end
