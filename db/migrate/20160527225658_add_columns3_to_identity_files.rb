class AddColumns3ToIdentityFiles < ActiveRecord::Migration
  def change
    add_column :identity_files, :thumbnail_skip, :boolean
  end
end
