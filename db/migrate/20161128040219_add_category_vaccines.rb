class AddCategoryVaccines < ActiveRecord::Migration
  def change
    Category.create(name: "vaccines", link: "vaccines", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/injection.png")
  end
end
