class CreateMealVitamins < ActiveRecord::Migration
  def change
    create_table :meal_vitamins do |t|
      t.references :identity, index: true
      t.references :meal, index: true
      t.references :vitamin, index: true

      t.timestamps
    end
  end
end
