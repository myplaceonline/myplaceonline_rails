class AddCategoryPassports < ActiveRecord::Migration
  def change
    Category.create(name: "passports", link: "passports", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/change_language.png")
  end
end
