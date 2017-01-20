class CreatePeriodicPaymentInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :periodic_payment_instances do |t|
      t.references :periodic_payment, foreign_key: true
      t.date :payment_date
      t.decimal :amount, precision: 10, scale: 2
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
