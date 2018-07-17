class CreateResearchPapers < ActiveRecord::Migration[5.1]
  def change
    create_table :research_papers do |t|
      t.references :document, foreign_key: true
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
