class CreateDocumentFiles < ActiveRecord::Migration
  def change
    create_table :document_files do |t|
      t.references :document, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
