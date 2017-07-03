class CreateFoodInformations < ActiveRecord::Migration[5.1]
  def change
    add_column :usda_foods, :id, :primary_key, first: true

    create_table :food_informations do |t|
      t.string :food_name
      t.text :notes
      t.references :usda_food, foreign_key: true
      t.references :identity, foreign_key: true

      t.timestamps
    end

    add_column :food_informations, :nutrient_databank_number, :string
    add_reference :food_informations, :usda_foods, foreign_key: true, index: true
  end
end
