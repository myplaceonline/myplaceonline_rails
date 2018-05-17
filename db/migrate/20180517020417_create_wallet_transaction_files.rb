class CreateWalletTransactionFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :wallet_transaction_files do |t|
      t.references :wallet_transaction, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public

      t.timestamps
    end
  end
end
