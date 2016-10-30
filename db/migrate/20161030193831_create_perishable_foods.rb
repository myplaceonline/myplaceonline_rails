class CreatePerishableFoods < ActiveRecord::Migration
  def change
    create_table :perishable_foods do |t|
      t.references :food, index: true, foreign_key: true
      t.date :purchased
      t.date :expires
      t.string :storage_location
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.integer :quantity
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
