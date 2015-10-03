class AddVisitCountToIdentityFileFolders < ActiveRecord::Migration
  def change
    add_column :identity_file_folders, :visit_count, :integer
  end
end
