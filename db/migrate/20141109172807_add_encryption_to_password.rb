class AddEncryptionToPassword < ActiveRecord::Migration
  def change
    add_column :passwords, :is_encrypted_password, :boolean
    add_reference :passwords, :encrypted_password, index: true
  end
end
