class CreateVehicleServices < ActiveRecord::Migration
  def change
    create_table :vehicle_services do |t|
      t.references :vehicle, index: true
      t.text :notes
      t.string :short_description
      t.date :date_due
      t.date :date_serviced
      t.text :service_location
      t.decimal :cost, precision: 10, scale: 2
      t.integer :miles

      t.timestamps
    end
  end
end
