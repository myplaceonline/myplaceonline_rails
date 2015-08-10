class AddExplicitCategoriesOptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :explicit_categories, :boolean
  end
end
