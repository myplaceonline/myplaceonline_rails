class AddCategoryBooks < ActiveRecord::Migration
  def change
    Category.create(name: "books", link: "books", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/book.png")
  end
end
