require "application_system_test_case"

class WhatdidiwearthensTest < ApplicationSystemTestCase
  setup do
    @whatdidiwearthen = whatdidiwearthens(:one)
  end

  test "visiting the index" do
    visit whatdidiwearthens_url
    assert_selector "h1", text: "Whatdidiwearthens"
  end

  test "creating a Whatdidiwearthen" do
    visit whatdidiwearthens_url
    click_on "New Whatdidiwearthen"

    fill_in "Archived", with: @whatdidiwearthen.archived
    fill_in "Identity", with: @whatdidiwearthen.identity_id
    check "Is public" if @whatdidiwearthen.is_public
    fill_in "Notes", with: @whatdidiwearthen.notes
    fill_in "Rating", with: @whatdidiwearthen.rating
    fill_in "Visit count", with: @whatdidiwearthen.visit_count
    fill_in "Weartime", with: @whatdidiwearthen.weartime
    click_on "Create Whatdidiwearthen"

    assert_text "Whatdidiwearthen was successfully created"
    click_on "Back"
  end

  test "updating a Whatdidiwearthen" do
    visit whatdidiwearthens_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @whatdidiwearthen.archived
    fill_in "Identity", with: @whatdidiwearthen.identity_id
    check "Is public" if @whatdidiwearthen.is_public
    fill_in "Notes", with: @whatdidiwearthen.notes
    fill_in "Rating", with: @whatdidiwearthen.rating
    fill_in "Visit count", with: @whatdidiwearthen.visit_count
    fill_in "Weartime", with: @whatdidiwearthen.weartime
    click_on "Update Whatdidiwearthen"

    assert_text "Whatdidiwearthen was successfully updated"
    click_on "Back"
  end

  test "destroying a Whatdidiwearthen" do
    visit whatdidiwearthens_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Whatdidiwearthen was successfully destroyed"
  end
end
