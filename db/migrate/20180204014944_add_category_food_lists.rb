class AddCategoryFoodLists < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "food_lists", link: "food_lists", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/text_list_numbers.png")
  end
end
