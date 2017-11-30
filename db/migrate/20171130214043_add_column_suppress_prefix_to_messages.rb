class AddColumnSuppressPrefixToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :suppress_prefix, :boolean
  end
end
