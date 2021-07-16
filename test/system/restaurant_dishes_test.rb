require "application_system_test_case"

class RestaurantDishesTest < ApplicationSystemTestCase
  setup do
    @restaurant_dish = restaurant_dishes(:one)
  end

  test "visiting the index" do
    visit restaurant_dishes_url
    assert_selector "h1", text: "Restaurant Dishes"
  end

  test "creating a Restaurant dish" do
    visit restaurant_dishes_url
    click_on "New Restaurant Dish"

    fill_in "Archived", with: @restaurant_dish.archived
    fill_in "Cost", with: @restaurant_dish.cost
    fill_in "Dish name", with: @restaurant_dish.dish_name
    fill_in "Identity", with: @restaurant_dish.identity_id
    check "Is public" if @restaurant_dish.is_public
    fill_in "Notes", with: @restaurant_dish.notes
    fill_in "Rating", with: @restaurant_dish.rating
    fill_in "Restaurant", with: @restaurant_dish.restaurant_id
    fill_in "Visit count", with: @restaurant_dish.visit_count
    click_on "Create Restaurant dish"

    assert_text "Restaurant dish was successfully created"
    click_on "Back"
  end

  test "updating a Restaurant dish" do
    visit restaurant_dishes_url
    click_on "Edit", match: :first

    fill_in "Archived", with: @restaurant_dish.archived
    fill_in "Cost", with: @restaurant_dish.cost
    fill_in "Dish name", with: @restaurant_dish.dish_name
    fill_in "Identity", with: @restaurant_dish.identity_id
    check "Is public" if @restaurant_dish.is_public
    fill_in "Notes", with: @restaurant_dish.notes
    fill_in "Rating", with: @restaurant_dish.rating
    fill_in "Restaurant", with: @restaurant_dish.restaurant_id
    fill_in "Visit count", with: @restaurant_dish.visit_count
    click_on "Update Restaurant dish"

    assert_text "Restaurant dish was successfully updated"
    click_on "Back"
  end

  test "destroying a Restaurant dish" do
    visit restaurant_dishes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Restaurant dish was successfully destroyed"
  end
end
