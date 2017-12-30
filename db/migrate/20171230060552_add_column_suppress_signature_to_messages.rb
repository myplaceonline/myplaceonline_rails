class AddColumnSuppressSignatureToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :suppress_signature, :boolean
  end
end
