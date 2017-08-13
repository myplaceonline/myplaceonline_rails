class AddColumns5ToIdentityFiles < ActiveRecord::Migration[5.1]
  def change
    add_column :identity_files, :thumbnail_filesystem_path, :string
    add_column :identity_files, :thumbnail_filesystem_size, :integer
  end
end
