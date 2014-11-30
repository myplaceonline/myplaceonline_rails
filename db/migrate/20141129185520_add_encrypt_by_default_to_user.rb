class AddEncryptByDefaultToUser < ActiveRecord::Migration
  def change
    # Default to false because the user needs to be ware of the pitfalls
    add_column :users, :encrypt_by_default, :boolean, default: false
  end
end
