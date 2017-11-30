class AddColumnSuppressPrefixToTextMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :text_messages, :suppress_prefix, :boolean
  end
end
