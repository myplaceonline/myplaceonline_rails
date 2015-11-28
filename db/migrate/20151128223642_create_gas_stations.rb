class CreateGasStations < ActiveRecord::Migration
  def change
    create_table :gas_stations do |t|
      t.references :location, index: true
      t.boolean :gas
      t.boolean :diesel
      t.boolean :propane_replacement
      t.boolean :propane_fillup
      t.integer :visit_count
      t.references :owner, index: true

      t.timestamps
    end
  end
end
