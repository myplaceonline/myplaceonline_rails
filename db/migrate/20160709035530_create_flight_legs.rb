class CreateFlightLegs < ActiveRecord::Migration
  def change
    create_table :flight_legs do |t|
      t.references :flight, index: true, foreign_key: true
      t.integer :flight_number
      t.references :flight_company, index: true, foreign_key: false
      t.string :depart_airport_code
      t.references :depart_location, index: true, foreign_key: false
      t.datetime :depart_time
      t.string :arrival_airport_code
      t.references :arrival_location, index: true, foreign_key: false
      t.datetime :arrive_time
      t.string :seat_number
      t.integer :position
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_foreign_key :flight_legs, :companies, column: :flight_company_id
    add_foreign_key :flight_legs, :locations, column: :depart_location_id
    add_foreign_key :flight_legs, :locations, column: :arrival_location_id
  end
end
