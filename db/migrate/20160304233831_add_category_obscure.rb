class AddCategoryObscure < ActiveRecord::Migration
  def change
    Category.create(name: "obscure", link: "obscure", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/donut.png")
  end
end
