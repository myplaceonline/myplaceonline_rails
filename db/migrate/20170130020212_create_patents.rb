class CreatePatents < ActiveRecord::Migration[5.0]
  def change
    create_table :patents do |t|
      t.string :patent_name
      t.string :patent_number
      t.string :authors
      t.string :region
      t.date :filed_date
      t.date :publication_date
      t.text :patent_abstract
      t.text :patent_text
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
