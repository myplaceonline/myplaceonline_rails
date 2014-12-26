class ChangePasswordColumns < ActiveRecord::Migration
  def change
    rename_column :passwords, :encrypted_password_id, :password_encrypted_id
    remove_column :passwords, :is_encrypted_password
  end
end
