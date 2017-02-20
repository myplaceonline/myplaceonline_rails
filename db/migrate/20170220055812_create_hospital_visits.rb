class CreateHospitalVisits < ActiveRecord::Migration[5.0]
  def change
    create_table :hospital_visits do |t|
      t.string :hospital_visit_purpose
      t.date :hospital_visit_date
      t.references :hospital, foreign_key: false
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true
      t.boolean :emergency_room

      t.timestamps
    end
    add_foreign_key :hospital_visits, :locations, column: :hospital_id
  end
end
