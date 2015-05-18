class AddColumnsToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :weight_type, :integer
    add_column :foods, :weight, :decimal, precision: 10, scale: 2
  end
end
