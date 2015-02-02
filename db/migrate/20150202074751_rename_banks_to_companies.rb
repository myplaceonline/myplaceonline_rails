class RenameBanksToCompanies < ActiveRecord::Migration
  def change
    rename_table :banks, :companies
  end
end
