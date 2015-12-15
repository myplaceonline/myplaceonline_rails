class CreateDrinks < ActiveRecord::Migration
  def change
    create_table :drinks do |t|
      t.references :identity, index: true
      t.string :drink_name
      t.text :notes
      t.decimal :calories, precision: 10, scale: 2
      t.decimal :price, precision: 10, scale: 2

      t.timestamps null: true
    end
  end
end
