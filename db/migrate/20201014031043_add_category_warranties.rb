class AddCategoryWarranties < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "warranties", link: "warranties", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/license_management.png")
  end
end
