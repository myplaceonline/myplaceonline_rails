class CreateTripFlights < ActiveRecord::Migration
  def change
    create_table :trip_flights do |t|
      t.references :trip, index: true, foreign_key: true
      t.references :flight, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
