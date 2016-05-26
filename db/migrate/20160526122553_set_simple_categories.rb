class SetSimpleCategories < ActiveRecord::Migration
  def change
    category = Category.where(name: "joy").first
    category.simple = true
    category.save!

    category = Category.where(name: "order").first
    category.simple = true
    category.save!

    category = Category.where(name: "meaning").first
    category.simple = true
    category.save!

    category = Category.where(name: "finance").first
    category.simple = true
    category.save!
  end
end
