class AddColumnsToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :important, :boolean
  end
end
