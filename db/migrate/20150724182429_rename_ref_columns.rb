class RenameRefColumns < ActiveRecord::Migration
  def change
    rename_column :identity_drivers_licenses, :ref_id, :identity_id
    rename_column :identity_emails, :ref_id, :identity_id
    rename_column :identity_locations, :ref_id, :identity_id
    rename_column :identity_phones, :ref_id, :identity_id
    rename_column :identity_pictures, :ref_id, :identity_id
    rename_column :identity_relationships, :ref_id, :identity_id
  end
end
