class AddColumnSuppressSignatureToEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :suppress_signature, :boolean
  end
end
