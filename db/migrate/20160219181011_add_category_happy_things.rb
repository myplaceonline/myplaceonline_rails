class AddCategoryHappyThings < ActiveRecord::Migration
  def change
    Category.create(name: "happy_things", link: "happy_things", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/teddy_bear.png")
  end
end
