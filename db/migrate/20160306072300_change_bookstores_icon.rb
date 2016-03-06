class ChangeBookstoresIcon < ActiveRecord::Migration
  def change
    category = Category.where(name: "book_stores").first
    if category.nil?
      raise "Category not found"
    end
    category.icon = "FatCow_Icons16x16/bookshelf.png"
    category.save!
  end
end
