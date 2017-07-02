class CreateNutrients < ActiveRecord::Migration[5.1]
  def change
    create_table :nutrients do |t|
      t.string :nutrient_name
      t.integer :measurement_type
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
