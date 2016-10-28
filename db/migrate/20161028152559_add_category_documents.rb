class AddCategoryDocuments < ActiveRecord::Migration
  def change
    Category.create(name: "documents", link: "documents", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/document_black.png")
  end
end
