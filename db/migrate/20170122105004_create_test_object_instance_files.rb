class CreateTestObjectInstanceFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :test_object_instance_files do |t|
      t.references :test_object_instance, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
