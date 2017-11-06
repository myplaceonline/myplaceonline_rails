class DropPrimaryIdentityColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :primary_identity_id
  end
end
