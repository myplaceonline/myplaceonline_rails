class RenameSubscriptionsToMemberships < ActiveRecord::Migration
  def change
    rename_table :subscriptions, :memberships
  end
end
