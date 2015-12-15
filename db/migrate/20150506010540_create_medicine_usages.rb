class CreateMedicineUsages < ActiveRecord::Migration
  def change
    create_table :medicine_usages do |t|
      t.datetime :usage_time
      t.references :medicine, index: true
      t.text :usage_notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
