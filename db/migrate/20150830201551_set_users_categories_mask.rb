class SetUsersCategoriesMask < ActiveRecord::Migration
  def change
    category = Category.where(name: "users").first
    category.user_type_mask = 1
    category.save!
  end
end
