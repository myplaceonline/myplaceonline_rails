require "application_system_test_case"

class GiftStoresTest < ApplicationSystemTestCase
  setup do
    @gift_store = gift_stores(:one)
  end

  test "visiting the index" do
    visit gift_stores_url
    assert_selector "h1", text: "Gift Stores"
  end

  test "creating a Gift store" do
    visit gift_stores_url
    click_on "New Gift Store"

    fill_in "Archived", with: @gift_store.archived
    fill_in "Identity", with: @gift_store.identity_id
    check "Is public" if @gift_store.is_public
    fill_in "Location", with: @gift_store.location_id
    fill_in "Notes", with: @gift_store.notes
    fill_in "Rating", with: @gift_store.rating
    fill_in "Visit count", with: @gift_store.visit_count
    click_on "Create Gift store"

    assert_text "Gift store was successfully created"
    click_on "Back"
  end

  test "updating a Gift store" do
    visit gift_stores_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @gift_store.archived
    fill_in "Identity", with: @gift_store.identity_id
    check "Is public" if @gift_store.is_public
    fill_in "Location", with: @gift_store.location_id
    fill_in "Notes", with: @gift_store.notes
    fill_in "Rating", with: @gift_store.rating
    fill_in "Visit count", with: @gift_store.visit_count
    click_on "Update Gift store"

    assert_text "Gift store was successfully updated"
    click_on "Back"
  end

  test "destroying a Gift store" do
    visit gift_stores_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gift store was successfully destroyed"
  end
end
