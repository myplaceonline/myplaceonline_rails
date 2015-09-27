class AddDefunctToBankAccounts < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :defunct, :datetime
  end
end
