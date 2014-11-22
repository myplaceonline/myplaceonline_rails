class AddTrackingToCategoryPointsAmount < ActiveRecord::Migration
  def change
    add_column :category_points_amounts, :visits, :integer
    add_column :category_points_amounts, :last_visit, :timestamp
  end
end
