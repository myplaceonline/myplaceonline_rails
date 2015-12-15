class CreateWeights < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.integer :amount_type
      t.date :measure_date
      t.string :source
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
