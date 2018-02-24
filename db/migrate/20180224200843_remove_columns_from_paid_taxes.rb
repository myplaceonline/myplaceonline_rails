class RemoveColumnsFromPaidTaxes < ActiveRecord::Migration[5.1]
  def change
    remove_column :paid_taxes, :paid_tax_description
  end
end
