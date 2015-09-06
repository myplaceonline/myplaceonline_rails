class AddCategoryNotepads < ActiveRecord::Migration
  def change
    Category.create(name: "notepads", link: "notepads", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/note.png")
  end
end
