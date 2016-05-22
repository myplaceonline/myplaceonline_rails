class AddColumnsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :recipe_category, :string
  end
end
