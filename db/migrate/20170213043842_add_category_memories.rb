class AddCategoryMemories < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "memories", link: "memories", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/flashlight_shine.png")
  end
end
