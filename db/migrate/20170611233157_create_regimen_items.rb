class CreateRegimenItems < ActiveRecord::Migration[5.1]
  def change
    create_table :regimen_items do |t|
      t.references :regimen, foreign_key: true
      t.string :regimen_item_name
      t.integer :position
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
