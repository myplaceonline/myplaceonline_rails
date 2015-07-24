class RenameContactIdentityReference < ActiveRecord::Migration
  def change
    rename_column :contacts, :ref_id, :identity_id
  end
end
