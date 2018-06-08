class AddColumnsThumbnail2ToIdentityFiles < ActiveRecord::Migration[5.1]
  def change
    add_column :identity_files, :thumbnail2_contents, :binary
    add_column :identity_files, :thumbnail2_size_bytes, :integer
    add_column :identity_files, :thumbnail2_filesystem_path, :string
    add_column :identity_files, :thumbnail2_filesystem_size, :integer
  end
end
