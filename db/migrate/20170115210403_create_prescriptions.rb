class CreatePrescriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :prescriptions do |t|
      t.string :prescription_name
      t.date :prescription_date
      t.text :notes
      t.references :doctor, foreign_key: false
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_foreign_key :prescriptions, :contacts, column: :doctor_id
  end
end
