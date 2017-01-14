class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
      t.text :quote_text
      t.date :quote_date
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
