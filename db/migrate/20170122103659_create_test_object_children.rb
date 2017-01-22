class CreateTestObjectChildren < ActiveRecord::Migration[5.0]
  def change
    create_table :test_object_instances do |t|
      t.references :test_object, foreign_key: true
      t.string :test_object_instance_name
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
