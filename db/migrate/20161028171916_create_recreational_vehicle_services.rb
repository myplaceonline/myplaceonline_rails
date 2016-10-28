class CreateRecreationalVehicleServices < ActiveRecord::Migration
  def change
    create_table :recreational_vehicle_services do |t|
      t.references :recreational_vehicle, index: true, foreign_key: true
      t.text :notes
      t.string :short_description
      t.date :date_due
      t.date :date_serviced
      t.string :service_location
      t.decimal :cost, precision: 10, scale: 2
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
