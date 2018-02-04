class AddCategoryExports < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "exports", link: "exports", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/saved_exports.png")
  end
end
