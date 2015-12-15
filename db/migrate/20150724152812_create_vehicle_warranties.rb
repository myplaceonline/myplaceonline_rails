class CreateVehicleWarranties < ActiveRecord::Migration
  def change
    create_table :vehicle_warranties do |t|
      t.references :owner, index: true
      t.references :warranty, index: true
      t.references :vehicle, index: true

      t.timestamps null: true
    end
  end
end
