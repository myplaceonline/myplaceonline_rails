class AddCategoryRegimens < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "regimens", link: "regimens", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/cargo.png")
  end
end
