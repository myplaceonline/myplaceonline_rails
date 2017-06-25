class CreateConsumedFoods < ActiveRecord::Migration[5.1]
  def change
    create_table :consumed_foods do |t|
      t.datetime :consumed_food_time
      t.references :food, foreign_key: true
      t.integer :quantity
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
