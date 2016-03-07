class AddEncryptionToSshKeys < ActiveRecord::Migration
  def change
    add_reference :ssh_keys, :ssh_private_key_encrypted, index: true, foreign_key: false
    add_foreign_key :ssh_keys, :encrypted_values, column: :ssh_private_key_encrypted_id
  end
end
