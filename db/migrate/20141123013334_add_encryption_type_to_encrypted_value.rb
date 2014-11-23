class AddEncryptionTypeToEncryptedValue < ActiveRecord::Migration
  def change
    add_column :encrypted_values, :encryption_type, :integer
  end
end
