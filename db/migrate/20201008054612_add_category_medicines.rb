class AddCategoryMedicines < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "medicines", link: "medicines", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/pill.png")
  end
end
