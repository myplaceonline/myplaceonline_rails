class CreateGiftStores < ActiveRecord::Migration[6.1]
  def change
    create_table :gift_stores do |t|
      t.references :location, foreign_key: true
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
