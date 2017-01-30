class AddCategoryPatents < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "patents", link: "patents", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/document_protect.png")
  end
end
