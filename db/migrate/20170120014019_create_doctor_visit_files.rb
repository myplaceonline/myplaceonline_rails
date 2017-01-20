class CreateDoctorVisitFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :doctor_visit_files do |t|
      t.references :doctor_visit, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
