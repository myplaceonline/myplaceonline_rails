class CreateMediaDumpFiles < ActiveRecord::Migration
  def change
    create_table :media_dump_files do |t|
      t.references :media_dump, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
