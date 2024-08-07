class CreateLocks < ActiveRecord::Migration[5.2]
  def change
    create_table :locks do |t|
      t.string :lock_name
      t.references :location, foreign_key: true
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
