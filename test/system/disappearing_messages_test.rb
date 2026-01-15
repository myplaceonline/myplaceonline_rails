require "application_system_test_case"

class DisappearingMessagesTest < ApplicationSystemTestCase
  setup do
    @disappearing_message = disappearing_messages(:one)
  end

  test "visiting the index" do
    visit disappearing_messages_url
    assert_selector "h1", text: "Disappearing Messages"
  end

  test "creating a Disappearing message" do
    visit disappearing_messages_url
    click_on "New Disappearing Message"

    fill_in "Archived", with: @disappearing_message.archived
    fill_in "Identity", with: @disappearing_message.identity_id
    check "Is public" if @disappearing_message.is_public
    fill_in "Name", with: @disappearing_message.name
    fill_in "Notes", with: @disappearing_message.notes
    fill_in "Rating", with: @disappearing_message.rating
    fill_in "Uuididentifier", with: @disappearing_message.uuididentifier
    fill_in "Visit count", with: @disappearing_message.visit_count
    click_on "Create Disappearing message"

    assert_text "Disappearing message was successfully created"
    click_on "Back"
  end

  test "updating a Disappearing message" do
    visit disappearing_messages_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @disappearing_message.archived
    fill_in "Identity", with: @disappearing_message.identity_id
    check "Is public" if @disappearing_message.is_public
    fill_in "Name", with: @disappearing_message.name
    fill_in "Notes", with: @disappearing_message.notes
    fill_in "Rating", with: @disappearing_message.rating
    fill_in "Uuididentifier", with: @disappearing_message.uuididentifier
    fill_in "Visit count", with: @disappearing_message.visit_count
    click_on "Update Disappearing message"

    assert_text "Disappearing message was successfully updated"
    click_on "Back"
  end

  test "destroying a Disappearing message" do
    visit disappearing_messages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Disappearing message was successfully destroyed"
  end
end
