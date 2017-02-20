class AddCategoryInjuries < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "injuries", link: "injuries", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/fire.png")
  end
end
