class CreatePeriodicPaymentFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :periodic_payment_files do |t|
      t.references :periodic_payment, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public

      t.timestamps
    end
  end
end
