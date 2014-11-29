class AddEncryptByDefaultToUser < ActiveRecord::Migration
  def change
    add_column :users, :encrypt_by_default, :boolean
  end
end
