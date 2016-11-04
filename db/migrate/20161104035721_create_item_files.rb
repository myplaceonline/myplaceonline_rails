class CreateItemFiles < ActiveRecord::Migration
  def change
    create_table :item_files do |t|
      t.references :item, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
