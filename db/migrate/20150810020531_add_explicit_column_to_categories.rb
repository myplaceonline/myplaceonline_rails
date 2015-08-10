class AddExplicitColumnToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :explicit, :boolean
  end
end
