class AddEncryptByDefaultToUser < ActiveRecord::Migration
  def change
    add_column :users, :encrypt_by_default, :boolean, default: true
  end
end
