class AddIndexToUnlockToken < ActiveRecord::Migration
  def change
    add_index :users, :unlock_token,         unique: true
  end
end
