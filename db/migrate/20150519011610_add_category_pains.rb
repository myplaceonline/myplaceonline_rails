class AddCategoryPains < ActiveRecord::Migration
  def change
    Category.create(name: "pains", link: "pains", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/fire.png")
  end
end
