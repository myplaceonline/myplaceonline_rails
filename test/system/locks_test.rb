require "application_system_test_case"

class LocksTest < ApplicationSystemTestCase
  setup do
    @lock = locks(:one)
  end

  test "visiting the index" do
    visit locks_url
    assert_selector "h1", text: "Locks"
  end

  test "creating a Lock" do
    visit locks_url
    click_on "New Lock"

    fill_in "Archived", with: @lock.archived
    fill_in "Identity", with: @lock.identity_id
    check "Is public" if @lock.is_public
    fill_in "Location", with: @lock.location_id
    fill_in "Lock name", with: @lock.lock_name
    fill_in "Notes", with: @lock.notes
    fill_in "Rating", with: @lock.rating
    fill_in "Visit count", with: @lock.visit_count
    click_on "Create Lock"

    assert_text "Lock was successfully created"
    click_on "Back"
  end

  test "updating a Lock" do
    visit locks_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @lock.archived
    fill_in "Identity", with: @lock.identity_id
    check "Is public" if @lock.is_public
    fill_in "Location", with: @lock.location_id
    fill_in "Lock name", with: @lock.lock_name
    fill_in "Notes", with: @lock.notes
    fill_in "Rating", with: @lock.rating
    fill_in "Visit count", with: @lock.visit_count
    click_on "Update Lock"

    assert_text "Lock was successfully updated"
    click_on "Back"
  end

  test "destroying a Lock" do
    visit locks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Lock was successfully destroyed"
  end
end
