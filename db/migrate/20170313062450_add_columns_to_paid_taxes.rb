class AddColumnsToPaidTaxes < ActiveRecord::Migration[5.0]
  def change
    add_column :paid_taxes, :paid_tax_description, :string
  end
end
