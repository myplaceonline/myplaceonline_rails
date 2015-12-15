class CreateMedicalConditions < ActiveRecord::Migration
  def change
    create_table :medical_conditions do |t|
      t.string :medical_condition_name
      t.text :notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
