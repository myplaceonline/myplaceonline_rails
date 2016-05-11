class ReorderMainCategories < ActiveRecord::Migration
  def change
    c = Category.where(name: "joy").first
    c.position = 0
    c.save!
    c = Category.where(name: "meaning").first
    c.position = 1
    c.save!
    c = Category.where(name: "order").first
    c.position = 2
    c.save!
  end
end
