class AddCategoryImports < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "imports", link: "imports", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/text_imports.png")
  end
end
