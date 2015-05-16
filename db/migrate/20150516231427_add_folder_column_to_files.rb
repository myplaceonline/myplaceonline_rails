class AddFolderColumnToFiles < ActiveRecord::Migration
  def change
    add_reference :identity_files, :folder, index: true
  end
end
