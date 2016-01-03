class RenameContactIdentity < ActiveRecord::Migration
  def change
    rename_column :contacts, :identity_id, :contact_identity_id
  end
end
