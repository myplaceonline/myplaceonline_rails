class ChangeBankAccountsColumn < ActiveRecord::Migration
  def change
    rename_column :bank_accounts, :bank_id, :company_id
  end
end
