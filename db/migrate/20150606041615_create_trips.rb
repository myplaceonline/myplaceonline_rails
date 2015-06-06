class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.references :location, index: true
      t.date :started
      t.date :ended
      t.text :notes
      t.boolean :work
      t.references :identity, index: true

      t.timestamps
    end
  end
end
