class RenameDefunctColumns < ActiveRecord::Migration
  def change
    rename_column :bank_accounts, :defunct, :archived
    rename_column :credit_cards, :defunct, :archived
    rename_column :dental_insurances, :defunct, :archived
    rename_column :health_insurances, :defunct, :archived
    rename_column :passwords, :defunct, :archived
  end
end
