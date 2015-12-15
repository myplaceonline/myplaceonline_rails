class CreateSkinTreatments < ActiveRecord::Migration
  def change
    create_table :skin_treatments do |t|
      t.datetime :treatment_time
      t.string :treatment_activity
      t.string :treatment_location
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
