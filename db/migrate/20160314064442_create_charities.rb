class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.references :location, index: true, foreign_key: true
      t.text :notes
      t.integer :rating
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
