class AddColumns2ToPaidTaxes < ActiveRecord::Migration[5.0]
  def change
    add_column :paid_taxes, :total_taxes_paid, :decimal, precision: 10, scale: 2
  end
end
