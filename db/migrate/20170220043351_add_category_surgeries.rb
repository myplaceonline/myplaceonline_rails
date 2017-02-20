class AddCategorySurgeries < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "surgeries", link: "surgeries", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/scalpel.png")
  end
end
