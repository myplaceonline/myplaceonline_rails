class AddCategoryTaxDocuments < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "tax_documents", link: "tax_documents", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/table_money.png")
  end
end
