class CreateParkFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :park_files do |t|
      t.references :park, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public

      t.timestamps
    end
  end
end