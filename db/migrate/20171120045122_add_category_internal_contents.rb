class AddCategoryInternalContents < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "internal_contents", link: "internal_contents", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/check_box_uncheck.png", internal: true, simple: true)
  end
end
