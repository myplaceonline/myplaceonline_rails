class AddColumns3ToPaidTaxes < ActiveRecord::Migration[5.0]
  def change
    add_column :paid_taxes, :agi, :decimal, precision: 10, scale: 2
  end
end
