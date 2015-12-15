class CreatePeriodicPayments < ActiveRecord::Migration
  def change
    create_table :periodic_payments do |t|
      t.string :periodic_payment_name
      t.text :notes
      t.date :started
      t.date :ended
      t.integer :date_period
      t.decimal :payment_amount, precision: 10, scale: 2
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
