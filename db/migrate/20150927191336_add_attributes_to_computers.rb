class AddAttributesToComputers < ActiveRecord::Migration
  def change
    add_column :computers, :dimensions_type, :integer
    add_column :computers, :width, :decimal, precision: 10, scale: 2
    add_column :computers, :height, :decimal, precision: 10, scale: 2
    add_column :computers, :depth, :decimal, precision: 10, scale: 2
    add_column :computers, :weight_type, :integer
    add_column :computers, :weight, :decimal, precision: 10, scale: 2
  end
end
