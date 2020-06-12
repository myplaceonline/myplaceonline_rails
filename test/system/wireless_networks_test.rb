require "application_system_test_case"

class WirelessNetworksTest < ApplicationSystemTestCase
  setup do
    @wireless_network = wireless_networks(:one)
  end

  test "visiting the index" do
    visit wireless_networks_url
    assert_selector "h1", text: "Wireless Networks"
  end

  test "creating a Wireless network" do
    visit wireless_networks_url
    click_on "New Wireless Network"

    fill_in "Archived", with: @wireless_network.archived
    fill_in "Identity", with: @wireless_network.identity_id
    check "Is public" if @wireless_network.is_public
    fill_in "Location", with: @wireless_network.location_id
    fill_in "Network names", with: @wireless_network.network_names
    fill_in "Notes", with: @wireless_network.notes
    fill_in "Password", with: @wireless_network.password_id
    fill_in "Rating", with: @wireless_network.rating
    fill_in "Visit count", with: @wireless_network.visit_count
    click_on "Create Wireless network"

    assert_text "Wireless network was successfully created"
    click_on "Back"
  end

  test "updating a Wireless network" do
    visit wireless_networks_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @wireless_network.archived
    fill_in "Identity", with: @wireless_network.identity_id
    check "Is public" if @wireless_network.is_public
    fill_in "Location", with: @wireless_network.location_id
    fill_in "Network names", with: @wireless_network.network_names
    fill_in "Notes", with: @wireless_network.notes
    fill_in "Password", with: @wireless_network.password_id
    fill_in "Rating", with: @wireless_network.rating
    fill_in "Visit count", with: @wireless_network.visit_count
    click_on "Update Wireless network"

    assert_text "Wireless network was successfully updated"
    click_on "Back"
  end

  test "destroying a Wireless network" do
    visit wireless_networks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Wireless network was successfully destroyed"
  end
end
