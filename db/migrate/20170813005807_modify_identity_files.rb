class ModifyIdentityFiles < ActiveRecord::Migration[5.1]
  def change
    remove_column :identity_files, :thumbnail_hash
    rename_column :identity_files, :thumbnail_bytes, :thumbnail_size_bytes
  end
end
