class ChangeWalletColumns < ActiveRecord::Migration[5.1]
  def change
    change_column :wallets, :balance, :decimal, :precision => 20, :scale => 8
    change_column :wallet_transactions, :transaction_amount, :decimal, :precision => 20, :scale => 8
    change_column :wallet_transactions, :exchange_rate, :decimal, :precision => 20, :scale => 8
    change_column :wallet_transactions, :fee, :decimal, :precision => 20, :scale => 8
    change_column :wallet_transactions, :exchanged_amount, :decimal, :precision => 20, :scale => 8
  end
end
