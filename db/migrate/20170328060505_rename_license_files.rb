class RenameLicenseFiles < ActiveRecord::Migration[5.0]
  def change
    rename_table :license_files, :software_license_files
    rename_column :software_license_files, :license_id, :software_license_id
  end
end
