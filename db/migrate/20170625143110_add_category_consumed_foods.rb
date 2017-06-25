class AddCategoryConsumedFoods < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "consumed_foods", link: "consumed_foods", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/omelet.png")
  end
end
