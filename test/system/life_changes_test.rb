require "application_system_test_case"

class LifeChangesTest < ApplicationSystemTestCase
  setup do
    @life_change = life_changes(:one)
  end

  test "visiting the index" do
    visit life_changes_url
    assert_selector "h1", text: "Life Changes"
  end

  test "creating a Life change" do
    visit life_changes_url
    click_on "New Life Change"

    fill_in "Archived", with: @life_change.archived
    fill_in "Identity", with: @life_change.identity_id
    check "Is public" if @life_change.is_public
    fill_in "Life change title", with: @life_change.life_change_title
    fill_in "Notes", with: @life_change.notes
    fill_in "Rating", with: @life_change.rating
    fill_in "Visit count", with: @life_change.visit_count
    click_on "Create Life change"

    assert_text "Life change was successfully created"
    click_on "Back"
  end

  test "updating a Life change" do
    visit life_changes_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @life_change.archived
    fill_in "Identity", with: @life_change.identity_id
    check "Is public" if @life_change.is_public
    fill_in "Life change title", with: @life_change.life_change_title
    fill_in "Notes", with: @life_change.notes
    fill_in "Rating", with: @life_change.rating
    fill_in "Visit count", with: @life_change.visit_count
    click_on "Update Life change"

    assert_text "Life change was successfully updated"
    click_on "Back"
  end

  test "destroying a Life change" do
    visit life_changes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Life change was successfully destroyed"
  end
end
