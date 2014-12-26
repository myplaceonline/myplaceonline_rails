class ChangePasswordSecretsColumns < ActiveRecord::Migration
  def change
    rename_column :password_secrets, :encrypted_answer_id, :answer_encrypted_id
    remove_column :password_secrets, :is_encrypted_answer
  end
end
