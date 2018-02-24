class AddColumns5ToPaidTaxes < ActiveRecord::Migration[5.1]
  def change
    add_column :paid_taxes, :local_taxes, :decimal, precision: 10, scale: 2
  end
end
