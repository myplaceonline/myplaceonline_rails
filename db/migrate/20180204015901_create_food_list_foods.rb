class CreateFoodListFoods < ActiveRecord::Migration[5.1]
  def change
    create_table :food_list_foods do |t|
      t.references :food, foreign_key: true
      t.references :food_list, foreign_key: true
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.integer :position
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
