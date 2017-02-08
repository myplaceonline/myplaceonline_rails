class AddColumns13ToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pending_encryption_switch, :boolean
  end
end
