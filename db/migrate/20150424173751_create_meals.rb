class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.datetime :meal_time
      t.text :notes
      t.references :location, index: true
      t.decimal :price, precision: 10, scale: 2
      t.decimal :calories, precision: 10, scale: 2
      t.references :identity, index: true

      t.timestamps
    end
  end
end
