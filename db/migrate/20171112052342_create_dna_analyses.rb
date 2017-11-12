class CreateDnaAnalyses < ActiveRecord::Migration[5.1]
  def change
    create_table :dna_analyses do |t|
      t.references :import, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
