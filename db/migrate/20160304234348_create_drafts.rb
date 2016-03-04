class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.string :draft_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
