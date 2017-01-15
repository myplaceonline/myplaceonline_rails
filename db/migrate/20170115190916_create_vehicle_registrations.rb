class CreateVehicleRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :vehicle_registrations do |t|
      t.references :vehicle, foreign_key: true
      t.string :registration_source
      t.date :registration_date
      t.decimal :amount, precision: 10, scale: 2
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
