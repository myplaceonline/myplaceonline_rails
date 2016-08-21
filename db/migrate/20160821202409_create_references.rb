class CreateReferences < ActiveRecord::Migration
  def change
    create_table :myreferences do |t|
      t.references :contact, index: true, foreign_key: true
      t.text :notes
      t.integer :reference_type
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
