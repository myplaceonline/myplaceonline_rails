require "application_system_test_case"

class MerchantAccountsTest < ApplicationSystemTestCase
  setup do
    @merchant_account = merchant_accounts(:one)
  end

  test "visiting the index" do
    visit merchant_accounts_url
    assert_selector "h1", text: "Merchant Accounts"
  end

  test "creating a Merchant account" do
    visit merchant_accounts_url
    click_on "New Merchant Account"

    fill_in "Archived", with: @merchant_account.archived
    fill_in "Currencies accepted", with: @merchant_account.currencies_accepted
    fill_in "Identity", with: @merchant_account.identity_id
    check "Is public" if @merchant_account.is_public
    fill_in "Limit daily", with: @merchant_account.limit_daily
    fill_in "Limit monthly", with: @merchant_account.limit_monthly
    fill_in "Merchant account name", with: @merchant_account.merchant_account_name
    fill_in "Notes", with: @merchant_account.notes
    fill_in "Rating", with: @merchant_account.rating
    fill_in "Ship to countries", with: @merchant_account.ship_to_countries
    fill_in "Visit count", with: @merchant_account.visit_count
    click_on "Create Merchant account"

    assert_text "Merchant account was successfully created"
    click_on "Back"
  end

  test "updating a Merchant account" do
    visit merchant_accounts_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @merchant_account.archived
    fill_in "Currencies accepted", with: @merchant_account.currencies_accepted
    fill_in "Identity", with: @merchant_account.identity_id
    check "Is public" if @merchant_account.is_public
    fill_in "Limit daily", with: @merchant_account.limit_daily
    fill_in "Limit monthly", with: @merchant_account.limit_monthly
    fill_in "Merchant account name", with: @merchant_account.merchant_account_name
    fill_in "Notes", with: @merchant_account.notes
    fill_in "Rating", with: @merchant_account.rating
    fill_in "Ship to countries", with: @merchant_account.ship_to_countries
    fill_in "Visit count", with: @merchant_account.visit_count
    click_on "Update Merchant account"

    assert_text "Merchant account was successfully updated"
    click_on "Back"
  end

  test "destroying a Merchant account" do
    visit merchant_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Merchant account was successfully destroyed"
  end
end
