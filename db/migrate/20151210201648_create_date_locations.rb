class CreateDateLocations < ActiveRecord::Migration
  def change
    create_table :date_locations do |t|
      t.references :location, index: true
      t.integer :visit_count
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
