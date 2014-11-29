class AddDetailColumnsToPassword < ActiveRecord::Migration
  def change
    add_column :passwords, :account_number, :string
  end
end
