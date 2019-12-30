class AddCategoryHaircuts < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "haircuts", link: "haircuts", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/cut.png")
  end
end
