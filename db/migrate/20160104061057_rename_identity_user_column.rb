class RenameIdentityUserColumn < ActiveRecord::Migration
  def change
    rename_column :identities, :owner_id, :user_id
  end
end
