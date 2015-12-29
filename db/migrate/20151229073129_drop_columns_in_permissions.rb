class DropColumnsInPermissions < ActiveRecord::Migration
  def change
    remove_column :permissions, :contact_id
  end
end
