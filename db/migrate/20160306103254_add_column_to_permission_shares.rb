class AddColumnToPermissionShares < ActiveRecord::Migration
  def change
    add_column :permission_shares, :child_selections, :string
  end
end
