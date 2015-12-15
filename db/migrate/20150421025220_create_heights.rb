class CreateHeights < ActiveRecord::Migration
  def change
    create_table :heights do |t|
      t.decimal :height_amount, precision: 10, scale: 2
      t.integer :amount_type
      t.date :measurement_date
      t.string :measurement_source
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
