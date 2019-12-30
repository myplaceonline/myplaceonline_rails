class CreateHaircuts < ActiveRecord::Migration[5.2]
  def change
    create_table :haircuts do |t|
      t.datetime :haircut_time
      t.decimal :total_cost, precision: 10, scale: 2
      t.references :cutter, foreign_key: false
      t.references :location, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_foreign_key :haircuts, :contacts, column: :cutter_id
  end
end
