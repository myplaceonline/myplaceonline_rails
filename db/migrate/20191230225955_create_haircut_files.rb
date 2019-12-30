class CreateHaircutFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :haircut_files do |t|
      t.references :haircut, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public

      t.timestamps
    end
  end
end
