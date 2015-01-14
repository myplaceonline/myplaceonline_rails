class AddColumnsToIdentityFiles < ActiveRecord::Migration
  def change
    add_column :identity_files, :notes, :text
  end
end
