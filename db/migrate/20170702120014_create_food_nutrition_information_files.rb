class CreateFoodNutritionInformationFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :food_nutrition_information_files do |t|
      t.references :food_nutrition_information, foreign_key: true, index: false
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
    add_index :food_nutrition_information_files, :food_nutrition_information_id, name: "fnif_on_fni"
  end
end
