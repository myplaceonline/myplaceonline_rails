class AddCategoryCafes < ActiveRecord::Migration
  def change
    Category.create(name: "cafes", link: "cafes", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/cup.png")
  end
end
