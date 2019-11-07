require "application_system_test_case"

class CrontabsTest < ApplicationSystemTestCase
  setup do
    @crontab = crontabs(:one)
  end

  test "visiting the index" do
    visit crontabs_url
    assert_selector "h1", text: "Crontabs"
  end

  test "creating a Crontab" do
    visit crontabs_url
    click_on "New Crontab"

    fill_in "Archived", with: @crontab.archived
    fill_in "Crontab name", with: @crontab.crontab_name
    fill_in "Dblocker", with: @crontab.dblocker
    fill_in "Identity", with: @crontab.identity_id
    check "Is public" if @crontab.is_public
    fill_in "Last success", with: @crontab.last_success
    fill_in "Minutes", with: @crontab.minutes
    fill_in "Notes", with: @crontab.notes
    fill_in "Rating", with: @crontab.rating
    fill_in "Run class", with: @crontab.run_class
    fill_in "Run data", with: @crontab.run_data
    fill_in "Run method", with: @crontab.run_method
    fill_in "Visit count", with: @crontab.visit_count
    click_on "Create Crontab"

    assert_text "Crontab was successfully created"
    click_on "Back"
  end

  test "updating a Crontab" do
    visit crontabs_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @crontab.archived
    fill_in "Crontab name", with: @crontab.crontab_name
    fill_in "Dblocker", with: @crontab.dblocker
    fill_in "Identity", with: @crontab.identity_id
    check "Is public" if @crontab.is_public
    fill_in "Last success", with: @crontab.last_success
    fill_in "Minutes", with: @crontab.minutes
    fill_in "Notes", with: @crontab.notes
    fill_in "Rating", with: @crontab.rating
    fill_in "Run class", with: @crontab.run_class
    fill_in "Run data", with: @crontab.run_data
    fill_in "Run method", with: @crontab.run_method
    fill_in "Visit count", with: @crontab.visit_count
    click_on "Update Crontab"

    assert_text "Crontab was successfully updated"
    click_on "Back"
  end

  test "destroying a Crontab" do
    visit crontabs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Crontab was successfully destroyed"
  end
end
