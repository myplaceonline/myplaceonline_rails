class CreateMedicines < ActiveRecord::Migration
  def change
    create_table :medicines do |t|
      t.string :medicine_name
      t.decimal :dosage, precision: 10, scale: 2
      t.integer :dosage_type
      t.text :notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
