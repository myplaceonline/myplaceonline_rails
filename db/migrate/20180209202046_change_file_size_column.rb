class ChangeFileSizeColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :identity_files, :file_file_size, :bigint
  end
end
