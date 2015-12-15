class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.references :location, index: true
      t.integer :rating
      t.text :notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
