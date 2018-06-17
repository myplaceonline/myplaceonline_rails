class CreateAllergies < ActiveRecord::Migration[5.1]
  def change
    create_table :allergies do |t|
      t.string :allergy_description
      t.date :started
      t.date :ended
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
