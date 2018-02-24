class AddColumns4ToPaidTaxes < ActiveRecord::Migration[5.1]
  def change
    add_column :paid_taxes, :fiscal_year, :integer
    add_column :paid_taxes, :federal_taxes, :decimal, precision: 10, scale: 2
    add_column :paid_taxes, :state_taxes, :decimal, precision: 10, scale: 2
  end
end
