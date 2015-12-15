class CreateIdentityFileFolders < ActiveRecord::Migration
  def change
    create_table :identity_file_folders do |t|
      t.string :folder_name
      t.references :parent_folder, index: true
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
