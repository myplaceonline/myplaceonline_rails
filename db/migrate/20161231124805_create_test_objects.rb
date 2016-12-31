class CreateTestObjects < ActiveRecord::Migration[5.0]
  def change
    create_table :test_objects do |t|
      t.string :test_object_name
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
