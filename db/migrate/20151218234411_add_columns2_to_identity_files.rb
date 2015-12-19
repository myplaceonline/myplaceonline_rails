class AddColumns2ToIdentityFiles < ActiveRecord::Migration
  def change
    add_column :identity_files, :filesystem_path, :string
  end
end
