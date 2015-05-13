class CreateMedicineUsageMedicines < ActiveRecord::Migration
  def change
    create_table :medicine_usage_medicines do |t|
      t.references :identity, index: true
      t.references :medicine_usage, index: true
      t.references :medicine, index: true

      t.timestamps
    end
  end
end
