class AddColumnsValidGuestActionsToPermissions < ActiveRecord::Migration[5.1]
  def change
    add_column :permissions, :valid_guest_actions, :string
    rename_column :permission_shares, :valid_actions, :valid_guest_actions
  end
end
