class CreateVitamins < ActiveRecord::Migration
  def change
    create_table :vitamins do |t|
      t.references :identity, index: true
      t.string :vitamin_name
      t.text :notes
      t.decimal :vitamin_amount, precision: 10, scale: 2
      t.integer :amount_type

      t.timestamps null: true
    end
  end
end
