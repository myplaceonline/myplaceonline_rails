class AddColumnQuantityToFinancialAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_assets, :quantity, :integer
  end
end
