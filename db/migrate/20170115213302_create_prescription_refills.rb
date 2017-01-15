class CreatePrescriptionRefills < ActiveRecord::Migration[5.0]
  def change
    create_table :prescription_refills do |t|
      t.references :prescription, foreign_key: true
      t.date :refill_date
      t.references :location, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
