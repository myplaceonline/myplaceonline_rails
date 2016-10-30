class AddCategoryPerishableFoods < ActiveRecord::Migration
  def change
    Category.create(name: "perishable_foods", link: "perishable_foods", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/spam.png")
  end
end
