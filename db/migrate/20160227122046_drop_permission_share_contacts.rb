class DropPermissionShareContacts < ActiveRecord::Migration
  def change
    drop_table :permission_share_contacts
  end
end
