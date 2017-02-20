class CreateSurgeries < ActiveRecord::Migration[5.0]
  def change
    create_table :surgeries do |t|
      t.string :surgery_name
      t.date :surgery_date
      t.references :hospital, foreign_key: false
      t.references :doctor, foreign_key: false
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_foreign_key :surgeries, :locations, column: :hospital_id
    add_foreign_key :surgeries, :doctors, column: :doctor_id
  end
end
