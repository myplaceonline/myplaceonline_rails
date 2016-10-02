class CreateLifeHighlights < ActiveRecord::Migration
  def change
    create_table :life_highlights do |t|
      t.datetime :life_highlight_time
      t.string :life_highlight_name
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
