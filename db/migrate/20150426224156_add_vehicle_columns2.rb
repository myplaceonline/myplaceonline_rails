class AddVehicleColumns2 < ActiveRecord::Migration
  def change
    add_column :vehicles, :price, :decimal, precision: 10, scale: 2
    add_column :vehicles, :msrp, :decimal, precision: 10, scale: 2
  end
end
