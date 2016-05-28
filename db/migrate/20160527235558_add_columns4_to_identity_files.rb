class AddColumns4ToIdentityFiles < ActiveRecord::Migration
  def change
    add_column :identity_files, :thumbnail_hash, :string
    add_column :identity_files, :file_hash, :string
  end
end
