class AddCategoryChecklists < ActiveRecord::Migration
  def change
    Category.create(name: "checklists", link: "checklists", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/check_boxes.png")
  end
end
