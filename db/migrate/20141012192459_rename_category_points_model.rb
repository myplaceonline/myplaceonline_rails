class RenameCategoryPointsModel < ActiveRecord::Migration
  def change
    rename_table :category_points, :category_points_amounts
  end
end
