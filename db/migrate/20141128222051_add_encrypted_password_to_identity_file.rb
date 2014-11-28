class AddEncryptedPasswordToIdentityFile < ActiveRecord::Migration
  def change
    add_reference :identity_files, :encrypted_password, index: true
  end
end
