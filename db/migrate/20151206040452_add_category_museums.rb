class AddCategoryMuseums < ActiveRecord::Migration
  def change
    Category.create(name: "museums", link: "museums", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/cup_gold.png")
  end
end
