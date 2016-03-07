class CreateAwesomeLists < ActiveRecord::Migration
  def change
    create_table :awesome_lists do |t|
      t.references :location, index: true, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
