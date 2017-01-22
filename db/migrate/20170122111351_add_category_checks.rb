class AddCategoryChecks < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "checks", link: "checks", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/cheque.png")
  end
end
