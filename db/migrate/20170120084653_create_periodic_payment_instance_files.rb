class CreatePeriodicPaymentInstanceFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :periodic_payment_instance_files do |t|
      t.references :periodic_payment_instance, foreign_key: true, index: false
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
    add_index :periodic_payment_instance_files, :periodic_payment_instance_id, name: "ppif_on_ppi"
  end
end
