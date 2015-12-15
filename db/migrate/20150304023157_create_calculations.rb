class CreateCalculations < ActiveRecord::Migration
  def change
    create_table :calculations do |t|
      t.string :name
      t.references :calculation_form, index: true
      t.decimal :result, precision: 10, scale: 2
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
