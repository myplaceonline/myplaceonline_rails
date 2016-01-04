class RenameIdentitiesOwner < ActiveRecord::Migration
  def change
    rename_column :identity_drivers_licenses, :identity_id, :parent_identity_id
    rename_column :identity_emails, :identity_id, :parent_identity_id
    rename_column :identity_locations, :identity_id, :parent_identity_id
    rename_column :identity_phones, :identity_id, :parent_identity_id
    rename_column :identity_pictures, :identity_id, :parent_identity_id
    rename_column :identity_relationships, :identity_id, :parent_identity_id
  end
end
