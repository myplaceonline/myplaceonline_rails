class AddEmailToPasswords < ActiveRecord::Migration
  def change
    add_column :passwords, :email, :string
  end
end
