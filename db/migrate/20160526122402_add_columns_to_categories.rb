class AddColumnsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :simple, :boolean
  end
end
