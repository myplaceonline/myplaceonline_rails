class CreateDietaryRequirementsCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :dietary_requirements_collections do |t|
      t.string :dietary_requirements_collection_name
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
