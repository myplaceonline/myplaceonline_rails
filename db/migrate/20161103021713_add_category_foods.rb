class AddCategoryFoods < ActiveRecord::Migration
  def change
    Category.create(name: "foods", link: "foods", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/chinese_noodles.png")
  end
end
