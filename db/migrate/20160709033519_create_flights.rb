class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.string :flight_name
      t.date :flight_start_date
      t.string :confirmation_number
      t.integer :visit_count
      t.text :notes
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
