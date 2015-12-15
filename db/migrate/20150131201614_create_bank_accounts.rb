class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.string :account_number
      t.references :account_number_encrypted, index: true
      t.string :routing_number
      t.references :routing_number_encrypted, index: true
      t.string :pin
      t.references :pin_encrypted, index: true
      t.references :password, index: true
      t.references :bank, index: true
      t.references :home_address, index: true
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
