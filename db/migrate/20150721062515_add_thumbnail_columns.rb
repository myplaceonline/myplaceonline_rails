class AddThumbnailColumns < ActiveRecord::Migration
  def change
    add_column :identity_files, :thumbnail_contents, :binary
    add_column :identity_files, :thumbnail_bytes, :integer
  end
end
