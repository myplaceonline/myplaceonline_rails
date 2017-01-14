class AddCategoryQuotes < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "quotes", link: "quotes", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/document_quote.png")
  end
end
