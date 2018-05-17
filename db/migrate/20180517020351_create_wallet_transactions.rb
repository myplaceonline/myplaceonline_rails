class CreateWalletTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :wallet_transactions do |t|
      t.references :wallet, foreign_key: true
      t.decimal :transaction_amount, precision: 10, scale: 2
      t.datetime :transaction_time
      t.string :short_description
      t.string :transaction_identifier
      t.references :contact, foreign_key: true
      t.integer :exchange_currency
      t.decimal :exchange_rate, precision: 10, scale: 2
      t.decimal :fee, precision: 10, scale: 2
      t.decimal :exchanged_amount, precision: 10, scale: 2
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
