class AddUserTypeMaskToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :user_type_mask, :integer
  end
end
