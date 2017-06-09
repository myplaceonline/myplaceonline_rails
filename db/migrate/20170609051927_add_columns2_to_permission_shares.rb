class AddColumns2ToPermissionShares < ActiveRecord::Migration[5.1]
  def change
    add_column :permission_shares, :valid_actions, :string
  end
end
