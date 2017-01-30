class CreatePatentFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :patent_files do |t|
      t.references :patent, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
