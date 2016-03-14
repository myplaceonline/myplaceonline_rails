class AddCategoryCharities < ActiveRecord::Migration
  def change
    Category.create(name: "charities", link: "charities", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/support.png")
  end
end
