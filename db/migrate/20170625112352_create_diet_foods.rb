class CreateDietFoods < ActiveRecord::Migration[5.1]
  def change
    create_table :diet_foods do |t|
      t.references :diet, foreign_key: true
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
