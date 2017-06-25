class CreateDietaryRequirements < ActiveRecord::Migration[5.1]
  def change
    create_table :dietary_requirements do |t|
      t.string :dietary_requirement_name
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
