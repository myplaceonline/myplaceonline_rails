class AddColumnsToPermissionShares < ActiveRecord::Migration
  def change
    add_reference :permission_shares, :email, index: true, foreign_key: true
  end
end
