class CreateDietaryRequirementsCollectionFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :dietary_requirements_collection_files do |t|
      t.references :dietary_requirements_collection, foreign_key: true, index: false
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
    add_index :dietary_requirements_collection_files, :dietary_requirements_collection_id, name: "drcf_on_drc"
  end
end
