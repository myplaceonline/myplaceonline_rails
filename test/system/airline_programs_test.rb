require "application_system_test_case"

class AirlineProgramsTest < ApplicationSystemTestCase
  setup do
    @airline_program = airline_programs(:one)
  end

  test "visiting the index" do
    visit airline_programs_url
    assert_selector "h1", text: "Airline Programs"
  end

  test "creating a Airline program" do
    visit airline_programs_url
    click_on "New Airline Program"

    fill_in "Archived", with: @airline_program.archived
    fill_in "Identity", with: @airline_program.identity_id
    check "Is public" if @airline_program.is_public
    fill_in "Membership", with: @airline_program.membership_id
    fill_in "Notes", with: @airline_program.notes
    fill_in "Password", with: @airline_program.password_id
    fill_in "Program name", with: @airline_program.program_name
    fill_in "Rating", with: @airline_program.rating
    fill_in "Status", with: @airline_program.status
    fill_in "Visit count", with: @airline_program.visit_count
    click_on "Create Airline program"

    assert_text "Airline program was successfully created"
    click_on "Back"
  end

  test "updating a Airline program" do
    visit airline_programs_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @airline_program.archived
    fill_in "Identity", with: @airline_program.identity_id
    check "Is public" if @airline_program.is_public
    fill_in "Membership", with: @airline_program.membership_id
    fill_in "Notes", with: @airline_program.notes
    fill_in "Password", with: @airline_program.password_id
    fill_in "Program name", with: @airline_program.program_name
    fill_in "Rating", with: @airline_program.rating
    fill_in "Status", with: @airline_program.status
    fill_in "Visit count", with: @airline_program.visit_count
    click_on "Update Airline program"

    assert_text "Airline program was successfully updated"
    click_on "Back"
  end

  test "destroying a Airline program" do
    visit airline_programs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Airline program was successfully destroyed"
  end
end
