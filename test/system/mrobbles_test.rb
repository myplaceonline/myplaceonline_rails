require "application_system_test_case"

class MrobblesTest < ApplicationSystemTestCase
  setup do
    @mrobble = mrobbles(:one)
  end

  test "visiting the index" do
    visit mrobbles_url
    assert_selector "h1", text: "Mrobbles"
  end

  test "creating a Mrobble" do
    visit mrobbles_url
    click_on "New Mrobble"

    fill_in "Archived", with: @mrobble.archived
    check "Finished" if @mrobble.finished
    fill_in "Identity", with: @mrobble.identity_id
    check "Is public" if @mrobble.is_public
    fill_in "Mrobble link", with: @mrobble.mrobble_link
    fill_in "Mrobble name", with: @mrobble.mrobble_name
    fill_in "Notes", with: @mrobble.notes
    fill_in "Rating", with: @mrobble.rating
    fill_in "Stopped watching time", with: @mrobble.stopped_watching_time
    fill_in "Visit count", with: @mrobble.visit_count
    click_on "Create Mrobble"

    assert_text "Mrobble was successfully created"
    click_on "Back"
  end

  test "updating a Mrobble" do
    visit mrobbles_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @mrobble.archived
    check "Finished" if @mrobble.finished
    fill_in "Identity", with: @mrobble.identity_id
    check "Is public" if @mrobble.is_public
    fill_in "Mrobble link", with: @mrobble.mrobble_link
    fill_in "Mrobble name", with: @mrobble.mrobble_name
    fill_in "Notes", with: @mrobble.notes
    fill_in "Rating", with: @mrobble.rating
    fill_in "Stopped watching time", with: @mrobble.stopped_watching_time
    fill_in "Visit count", with: @mrobble.visit_count
    click_on "Update Mrobble"

    assert_text "Mrobble was successfully updated"
    click_on "Back"
  end

  test "destroying a Mrobble" do
    visit mrobbles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mrobble was successfully destroyed"
  end
end
