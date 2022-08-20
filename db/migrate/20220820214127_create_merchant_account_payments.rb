class CreateMerchantAccountPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :merchant_account_payments do |t|
      t.references :merchant_account, foreign_key: true
      t.string :payment_name
      t.decimal :amount_per_payment, precision: 10, scale: 2
      t.decimal :percent_total
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public
      t.text :notes

      t.timestamps
    end
  end
end
