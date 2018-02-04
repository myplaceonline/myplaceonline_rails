class CreateFoodLists < ActiveRecord::Migration[5.1]
  def change
    create_table :food_lists do |t|
      t.string :food_list_name
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
