class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.references :identity, index: true
      t.string :food_name
      t.text :notes
      t.decimal :calories, precision: 10, scale: 2
      t.decimal :price, precision: 10, scale: 2

      t.timestamps null: true
    end
  end
end
