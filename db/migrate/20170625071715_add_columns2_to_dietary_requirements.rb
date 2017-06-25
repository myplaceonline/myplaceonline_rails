class AddColumns2ToDietaryRequirements < ActiveRecord::Migration[5.1]
  def change
    add_reference :dietary_requirements, :dietary_requirements_collection, foreign_key: true, index: false
    add_index :dietary_requirements, :dietary_requirements_collection_id, name: "dr_on_drci"
  end
end
