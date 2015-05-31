class AddIconToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :icon, :string
    Category.reset_column_information
  end
end
