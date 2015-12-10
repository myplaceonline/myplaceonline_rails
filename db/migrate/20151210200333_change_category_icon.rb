class ChangeCategoryIcon < ActiveRecord::Migration
  def change
    category = Category.where(name: "memberships").first
    if category.nil?
      raise "Category not found"
    end
    category.icon = "FatCow_Icons16x16/protect_share_workbook.png"
    category.save!
  end
end
