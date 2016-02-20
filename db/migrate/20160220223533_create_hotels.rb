class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.references :location, index: true, foreign_key: true
      t.integer :breakfast_rating
      t.integer :overall_rating
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
