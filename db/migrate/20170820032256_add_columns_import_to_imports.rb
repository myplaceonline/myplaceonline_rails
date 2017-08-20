class AddColumnsImportToImports < ActiveRecord::Migration[5.1]
  def change
    add_column :imports, :import_status, :integer
    add_column :imports, :import_progress, :text
  end
end
