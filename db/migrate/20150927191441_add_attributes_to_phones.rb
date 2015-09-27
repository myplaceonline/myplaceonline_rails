class AddAttributesToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :dimensions_type, :integer
    add_column :phones, :width, :decimal, precision: 10, scale: 2
    add_column :phones, :height, :decimal, precision: 10, scale: 2
    add_column :phones, :depth, :decimal, precision: 10, scale: 2
    add_column :phones, :weight_type, :integer
    add_column :phones, :weight, :decimal, precision: 10, scale: 2
  end
end
